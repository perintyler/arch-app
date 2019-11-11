from api.serializers import mUserSerializer, MobileAppDataSerializer
from rest_framework.viewsets import ModelViewSet
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import action

class UserViewSet(ModelViewSet):

    permission_classes = (IsAuthenticated,)
    serializer_class = MobileAppDataSerializer

    def get_queryset(self):
        return self.request.user

    def list(self, request):
        user = request.user.m_user
        serializer = MobileAppDataSerializer(user)
        return Response(serializer.data)




class FriendViewSet(ModelViewSet):

    permission_classes = (IsAuthenticated,)
    serializer_class = mUserSerializer

    def get_queryset(self):
        qs = self.request.user.m_user.friends.order_by('name')
        for u in qs.all():
            if u.name == "Allen Salama":
                print("***************")
                print("bleh")
                print("***************")
        return qs
