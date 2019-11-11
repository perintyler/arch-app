# from api.models import Squad, mUser, Notification
# from api.serializers import SquadSerializer
# from rest_framework import generics, viewsets, status
# from rest_framework.response import Response
# from rest_framework.views import APIView
# from rest_framework.decorators import action
# import json
#
#
# #TODO make model view set into api view
# class SquadViewSet(viewsets.ModelViewSet, generics.CreateAPIView):
#
#     serializer_class = SquadSerializer
#     queryset = Squad.objects.all()
#
#     def retrieve(self, request, pk=None):
#         squad = Squad.objects.get(pk=pk)
#         serializer = SquadSerializer(squad)
#         return Response(serializer.data)
#
#     @action(methods=['post'], detail=True)
#     def add(self, request, pk=None):
#         squad = self.get_object()
#         data = json.loads(request.body)
#         inviter = mUser.objects.get(pk=data['inviterPK'])
#
#         usersToAdd = mUser.objects.filter(facebookID__in=data["FBIDs"]).exclude(squads__pk__contains=squad.pk)
#         for user in usersToAdd:
#             user.squads.add(squad)
#             notifImage = "http://graph.facebook.com/{}/picture?type=small".format(inviter.facebookID)
#             newNotification = Notification(user=user, type="addedToGroup", friendName=inviter.name, redirectID=squad.id, itemName=squad.name, imageUrl=notifImage)
#             newNotification.save()
#             # push notification
#             unreadNotifCount = Notification.objects.filter(user=user).filter(viewed=False).count()
#             NotificationHelper.sendPushNotif(interests=[str(user.id)], badge=unreadNotifCount, message="You've been invited to {}'s group {}".format(inviter.name, squad.name))
#
#         return Response(status.HTTP_200_OK)
#
#
#     @action(methods=['post'], detail=True)
#     def leave(self, request, pk=None):
#         squad = self.get_object()
#         data = json.loads(request.body)
#         user = mUser.objects.get(pk=data['userID'])
#         user.squads.remove(squad)
#         return Response(status.HTTP_200_OK)
#
#
#
#
# class CreateSquadView(APIView):
#
#     def post(self,request, format=None):
#         data = json.loads(request.body)
#         fbIDs = data["FBIDs"]
#         name = data["name"]
#         creator = mUser.objects.get(pk=data["creator"])
#         usersToInvite = mUser.objects.filter(facebookID__in=fbIDs)
#         squadsToInvite = Squad.objects.filter(pk__in=data["groups"])
#
#         squad = Squad(creator=creator, name=name)
#
#         if("image" in data):
#             squad.image = data["image"]
#         if("desc" in data):
#             squad.desc = data["desc"]
#
#         squad.save()
#
#         creator.squads.add(squad)
#
#         for user in usersToInvite:
#             user.squads.add(squad)
#
#         for invited_squad in squadsToInvite:
#             for invited_user in squad.users.exclude(facebookID__in=fbIDs).exclude(pk=creator.pk):
#                 invited_user.squads.add()
#                 notifImage = "http://graph.facebook.com/{}/picture?type=small".format(creator.facebookID)
#                 newNotification = Notification(user=invited_user, type="addedToGroup", redirectID=squad.pk, itemName=squad.name, imageUrl=notifImage)
#                 newNotification.save()
#                 # push notification
#                 unreadNotifCount = Notification.objects.filter(user=invited_user).filter(viewed=False).count()
#                 NotificationHelper.sendPushNotif(interests=[str(invited_user.id)], message="You've been invited to {}'s new group {}".format(creator.name, creator.name), badge=unreadNotifCount)
#
#         return Response(status.HTTP_201_CREATED)
