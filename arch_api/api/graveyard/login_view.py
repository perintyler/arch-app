# from api.models import mUser
# from api.serializers import mUserSerializer
# from rest_framework.response import Response
# from rest_framework.views import APIView
# from django.db.models import F, Q
# from rest_framework.permissions import IsAuthenticated
# from rest_framework.authentication import BasicAuthentication
# from api.authentication import CsrfExemptSessionAuthentication
# from api.extras import facebookUtil as fb
# import json
#
#
# """
# This view is called every time a mobile user logs in. If a user with the posted
# facebook ID doesn't exist, a new user is created. The retrieved or created user
# object is serialized and returned in the response.
# """
# class LoginView(APIView):
#
#     permission_classes = (IsAuthenticated,)
#
#     def get(self, request, format=None):
#         # get the mUser which is set in the middleware
#         print("inside view")
#         user = self.request.user.m_user
#
#         # get facebook friends list from post data and update users friends property
#         # updated_friends_qs = mUser.objects.filter(facebookID__in=json.loads(request.body)["friends"])
#         # user.friends.set(fb.get_friends_queryset())
#         # user.save()
#
#         # return serialized mUser data
#         serializer = mUserSerializer(user)
#         return Response(serializer.data)
