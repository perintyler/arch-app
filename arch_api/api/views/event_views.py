from api.models import Event, Venue, mUser, Discount, Notification, Action, Transaction
from api.serializers import mUserSerializer, EventSerializer, NotificationSerializer, DiscountSerializer
from api.extras import Push
from rest_framework import viewsets, generics, status
from rest_framework.decorators import list_route
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.decorators import action
import json
from rest_framework.authentication import BasicAuthentication
from rest_framework.permissions import IsAuthenticated
from api.authentication import CsrfExemptSessionAuthentication
from api.permissions import EventCreatorPermission
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt
from rest_framework.authentication import BasicAuthentication
from api.authentication import CsrfExemptSessionAuthentication
import datetime
from django.db.models import Q, F, Max
from django.db import IntegrityError
from api.extras import Push

class EventViewSet(viewsets.ModelViewSet):

    serializer_class = EventSerializer
    authentication_classes = (CsrfExemptSessionAuthentication,)# BasicAuthentication)
    permission_classes = (IsAuthenticated,)

    def get_queryset(self):
        if self.action == 'retrieve':
            return Event.objects
        else:
            return self.request.user.m_user.attending.filter(expired=False)

    def create(self, request):
        fields = json.loads(request.body)
        creator = self.request.user.m_user
        venue = Venue.objects.get(pk=fields['venue'])
        # parse the posted string date into a datetime object
        date = datetime.datetime.strptime(fields['date'], "%Y-%m-%d").date()
        desc = None if "desc" not in fields else fields['desc']
        # create and save a new event using post fields
        new_event = Event.objects.create(creator = creator, name = fields['name'],
                                            has_image = fields['has_image'], desc = desc,
                                                venue = venue, date = date)

        # add the creator the the list of attendees and save
        new_event.attending.add(creator)
        new_event.save()

        # create a new action for the stream
        Action.objects.create(user=creator, event=new_event)

        # serialize and return the event
        serializer = EventSerializer(new_event)
        return Response(serializer.data)


    @action(methods=['post'], detail=True)
    def invite(self, request, pk=None):
        data = json.loads(request.body)
        event = self.get_object()
        requester = request.user.m_user

        # set the url of the notification image to the inviters facebook picture
        notifImage = "http://graph.facebook.com/{}/picture?type=small".format(requester.facebookID)

        # query users to invite using the posted list of facebook ids
        users_to_invite = mUser.objects.filter(facebookID__in = data['facebook_ids'])

        # remove any users who have already been invited
        # users_to_invite.exclude(notifications_users=F('pk'))

        for invitee in users_to_invite:
            # get or create the notification object
            notification, created = Notification.objects.get_or_create(user = invitee, event = event, inviter=requester)

            # if a notification with for the user and event didn't already
            # exist, send a push notification to the user
            if created:
                # send push notification to invitee using pusher
                Push.send_notification(
                    header="New Event",
                    type="event",
                    interests = [str(invitee.firebaseID)],
                    redirect=str(event.id),
                    badge = invitee.notifications.filter(viewed=False).count(), # number of unread notifications
                    message = "You've been invited to {}'s event {}".format(requester.name, event.name),
                )

        #return response indicating success
        return Response(status.HTTP_200_OK)


    @action(methods=['get'], detail=True)
    def attend(self, request, pk=None):
        #get user and the event the user wants to attend
        user = request.user.m_user
        event = Event.objects.get(pk=pk)

        # check to see if adding a user would mean the event has reached
        # a new discount threshold
        event_size = event.attending.count() + 1 #add 1 to account for new user
        if(event.venue.discounts.filter(size=event_size).exists()):

            requester_fb_pic = "http://graph.facebook.com/{}/picture?type=small".format(user.facebookID)

            #send a push notification to every attending user informing them of new discount
            for attendee in event.attending.all():

                #send push notification to attending user
                Push.send_notification(interests = [str(attendee.firebaseID)],
                                                    badge = attendee.notifications.filter(viewed=False).count(), #amount of unread notifications
                                                        message="{} has reached a new discount threshold!".format(event.name),
                                                            header="New Event", type="event",
                                                                redirect=str(event.id))


        #add event to users relation to attending events and remove it from invited
        user.attending.add(event)
        user.save()

        #create and save action for user joining event
        Action.objects.create(user=user, event=event)

        #return response indicating a successfull event add
        return Response(status.HTTP_200_OK)

    @action(methods=['get'], detail=True)
    def leave(self, request, pk=None):
        event = self.get_object()
        request.user.m_user.attending.remove(event)
        return Response(status.HTTP_200_OK)


    @action(methods=['get'], detail=True)
    def checkin(self, request, pk=None):
        user = request.user.m_user
        event = self.get_object()
        event.checkedIn.add(user)
        return Response(status.HTTP_200_OK)

    @action(methods=['post'], detail=True)
    def claim(self, request, pk=None):
        # data = json.loads(request.body)
        #
        # discount = Discount.objects.get(pk=data['discount'])
        # user = request.user.m_user
        # event = self.get_object()
        #
        # Transaction.objects.create(user=user, event=event, discount=discount)
        return Response(status.HTTP_200_OK)




    @action(methods=['get'], detail=True)
    def discounts(self, request, pk=None):

        # get the user making the request and the event
        user = request.user.m_user
        event = self.get_object()

        # get all discount points with reached thresholds
        eventSize = event.attending.count()
        discount_qs = event.venue.discounts.filter(size__lte=eventSize)
        discounts = []

        # one time use discounts
        single_use_qs = discount_qs.filter(single_use=True)
        if single_use_qs.exists():
            single_use_discount = single_use_qs.first()
            transaction_qs = event.transactions.filter(Q(user=user) & Q(discount=single_use_discount))
            if not transaction_qs.exists():
                discounts.append(single_use_discount)


        percentage_discount_qs = discount_qs.filter(type="*% Off")
        if(percentage_discount_qs.exists()):
            discount_size = percentage_discount_qs.aggregate(Max('size'))['size__max']
            percentage_discount = percentage_discount_qs.get(size=discount_size)
            discounts.append(percentage_discount)
            # return qs | DiscountPoint.objects.get(pk=percentageDP.pk)

        # promotional_discount_qs = discount_qs.filter(Q(type="$* Wells") | Q(type="$* Domestics"))
        # if promotional_discount_qs.exists():
        #     for discount in promotional_discount_qs.all():
        #         discounts.append(discount)

        serializer = DiscountSerializer(discounts, many=True)
        return Response(serializer.data)


    @action(methods=['get'], detail=True)
    def invitable(self, request, pk=None):

        # get the user making the request and the event
        user = request.user.m_user
        event = self.get_object()

        friends = user.friends

        friend_pks = friends.values_list('pk')

        # get notifications already sent to friends for event
        already_sent_notifs = Notification.objects.filter(Q(event=event) & Q(user__in=friend_pks))
        already_notified_users = already_sent_notifs.values_list('user')

        invitable_friends = friends.exclude(pk__in=already_notified_users)

        # order the friends alphabateically
        sorted_friends = invitable_friends.order_by('name')
        serializer = mUserSerializer(sorted_friends, many=True)
        return Response(serializer.data)
