#
# class NotificationViewSet(ModelViewSet):
#
#     permission_classes = (IsAuthenticated,)
#     serializer_class = NotificationSerializer
#     queryset = Notification.objects.all()
#
#
#     def get_queryset(self):
#         user = self.request.user.m_user
#         notif_qs = Notification.objects.filter(user=user.pk)
#         notif_qs.update(viewed=True)
#         return notif_qs.order_by('-date')
#
#     @action(methods=['get'], detail=True)
#     def numUnread(self, request, pk=None):
#         e = Notification.objects.filter(user=pk).filter(viewed=False).count()
#         return Response(e)
#
#
#     """ DEBUGGING PURPOSES ONLY """
#     @action(methods=['get'], detail=True)
#     def differet(self, request, pk=None):
#         interest = 'hello' if pk==None else pk
#         pn_client = PushNotifications(
#             instance_id='a3bb9382-e554-4929-8b2a-bf4f728a67fa',
#             secret_key='AAC3FEB358A597E2ADDEE4377DC3E03',
#         )
#         response = pn_client.publish(
#           interests=[str(interest)],
#           publish_body={
#             'apns': {
#               'aps': {
#                 'alert': 'Yoooo!',
#               },
#             },
#           },
#         )
#         return Response(status.HTTP_200_OK)
