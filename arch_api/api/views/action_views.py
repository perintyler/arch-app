from api.models import Action, mUser
from api.serializers import ActionSerializer
from rest_framework import viewsets, generics, status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.decorators import action
from rest_framework.pagination import PageNumberPagination
from rest_framework.permissions import IsAuthenticated
import json
from django.http import JsonResponse
from django.core import serializers
from rest_framework.mixins import ListModelMixin
from django.db.models import Q
from datetime import date, timedelta

class Paginator(PageNumberPagination):

    page_size = 1
    page_size_query_param = 'page_size'
    max_page_size = 2

class ActionViewSet(viewsets.ModelViewSet):

    permission_classes = (IsAuthenticated,)
    serializer_class = ActionSerializer
    # pagination_class = Paginator

    def get_queryset(self):
        requester = self.request.user.m_user
        user_friends = requester.friends.values_list('pk')
        today = date.today() - timedelta(2)
        action_qs = Action.objects.filter(Q(user__in=user_friends), ~Q(user=requester), Q(event__date__gt=today))
        return action_qs.order_by('event__date')
