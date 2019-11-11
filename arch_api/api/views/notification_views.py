from pusher_push_notifications import PushNotifications
from rest_framework import viewsets, generics, status
from api.models import Notification
from api.serializers import NotificationSerializer
from rest_framework.response import Response
from rest_framework.viewsets import ModelViewSet
from rest_framework.decorators import action
from rest_framework.permissions import IsAuthenticated

class NotificationViewSet(ModelViewSet):

    permission_classes = (IsAuthenticated,)
    serializer_class = NotificationSerializer
    queryset = Notification.objects.all()

    def list(self, request):
        notif_qs = self.get_queryset()
        notif_qs.update(viewed=True)
        serializer = NotificationSerializer(notif_qs, many=True)
        return Response(serializer.data)

    def get_queryset(self):
        return self.request.user.m_user.notifications
