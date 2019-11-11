# from api.models import Squad, Message
# from api.serializers import MessageSerializer
# from rest_framework.viewsets import ModelViewSet
# from rest_framework.decorators import action
# from api.models import Event
# from rest_framework import status
#
#
# class GroupMessageViewSet(ModelViewSet):
#
#     lookup_field = 'squad_id'
#     queryset = Message.objects.all()
#     serializer_class = MessageSerializer
#
#     @action(methods=['post'], detail=True)
#     def send(self, request, pk=None):
#         data = json.loads(request.body)
#         squad = self.get_object().squad
#         sender = mUser.objects.get(pk=data["senderID"])
#         message_content = data["content"]
#         new_message = Message(sender=sender, squad=squad, content=message_content)
#         new_message.save()
#         return Response(status.HTTP_200_OK)
#
#
# class EventMessageViewSet(ModelViewSet):
#
#     lookup_field = 'event_id'
#     queryset = Message.objects.all()
#     serializer_class = MessageSerializer
#
#     @action(methods=['post'], detail=True)
#     def send(self, request, pk=None):
#         data = json.loads(request.body)
#         event = self.get_object().event
#         sender = mUser.objects.get(pk=data["senderID"])
#         message_content = data["content"]
#         new_message = Message(sender=sender, event=event, content=message_content)
#         new_message.save()
#         return Response(status.HTTP_200_OK)
