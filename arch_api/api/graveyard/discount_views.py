# from api.models import Discount, mUser, Event
# from api.serializers import DiscountSerializer
# from rest_framework.response import Response
# from rest_framework.viewsets import ModelViewSet
# from rest_framework.decorators import action
# from datetime import datetime
# from django.db.models import Q
# from rest_framework.permissions import IsAuthenticated
# from django.db.models import Max
#
# class DiscountViewSet(ModelViewSet):
#
#     permission_classes = (IsAuthenticated,)
#     serializer_class = DiscountSerializer
#     queryset = Discount.objects.all()
#
#     def retrieve(self, request, pk=None):
#         user = request.user.m_user
#         discount = self.get_object()
#         event = Event.objects.get(pk=data['eventID'])
#
#         newTransaction = Transaction(
#             user=user, venue=event.venue, event=event, discount=discount)
#         newTransaction.save()
#         return Response(status.HTTP_200_OK)
