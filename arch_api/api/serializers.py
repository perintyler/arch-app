from rest_framework.serializers import ModelSerializer, SerializerMethodField, DateField
from api.models import mUser, Venue, Event, Discount, Action, Notification


"""
### Discount
"""
class DiscountSerializer(ModelSerializer):

    class Meta:
        model = Discount
        fields = ('id','size','type','constant')


"""
### Venue
"""
class VenueSerializer(ModelSerializer):

    discounts = SerializerMethodField()

    class Meta:
        model = Venue
        fields = ('id','name','image','desc','address','discounts')

    def get_discounts(self, venue):
        # filter the discounts by size
        discounts = venue.discounts.order_by('size')
        # create a discount serializer using the qs of sorted discounts
        serializer = DiscountSerializer(discounts, many=True)
        # return the serialized discounts
        return serializer.data


"""
### User
"""
class mUserSerializer(ModelSerializer):

    class Meta:
        model = mUser
        fields = ('name','facebookID')

"""
### Event
"""
class EventSerializer(ModelSerializer):

    creator = mUserSerializer()
    attendance = mUserSerializer(source='attending',many=True)
    venue = VenueSerializer()
    date = DateField()
    isAttending = SerializerMethodField()

    class Meta:
        model = Event
        fields = ('id','creator','name','date','desc','has_image','venue','attendance', 'isAttending')

    def get_isAttending(self, event):
        if 'request' not in self.context:
            return True
        else:
            user = self.context['request'].user.m_user
            return event.attending.filter(pk=user.pk).exists()
"""
### Stream
"""
class ActionSerializer(ModelSerializer):

    user = mUserSerializer()
    venueName = SerializerMethodField()
    eventDate = SerializerMethodField()

    class Meta:
        model = Action
        fields = ('user', 'eventDate', 'venueName')

    def get_eventDate(self, action):
        return str(action.event.date)

    def get_venueName(self, action):
        return action.event.venue.name

"""
### Notification
"""
class NotificationSerializer(ModelSerializer):

    inviter = mUserSerializer()
    eventName = SerializerMethodField()
    eventID = SerializerMethodField()

    class Meta:
        model = Notification
        fields = ('inviter','eventName', 'eventID', 'viewed')

    def get_eventName(self, notification):
        return notification.event.name

    def get_eventID(self, notification):
        return notification.event.pk


"""
App Startup Data
"""
class MobileAppDataSerializer(ModelSerializer):

    venues = SerializerMethodField()
    num_unread_notifs = SerializerMethodField()
    user_events = EventSerializer(source='attending', many=True)

    class Meta:
        model = mUser
        fields = ('venues', 'user_events', 'num_unread_notifs')

    def get_venues(self, user):
        venues = Venue.objects.all()
        serializer = VenueSerializer(venues, many=True)
        return serializer.data

    def get_num_unread_notifs(self, user):
        return user.notifications.filter(viewed=False).count()
