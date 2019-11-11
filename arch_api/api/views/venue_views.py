from api.models import Venue
from api.serializers import VenueSerializer, DiscountSerializer
from rest_framework import viewsets
from rest_framework.response import Response
from rest_framework.decorators import action
from rest_framework.permissions import IsAuthenticated

class VenueViewSet(viewsets.ModelViewSet):

    permission_classes = (IsAuthenticated,)
    queryset = Venue.objects.all()
    serializer_class = VenueSerializer

    # def list(self, request):
    #     queryset = Venue.objects.all()
    #     serializer = VenueSerializer(queryset, many=True)
    #     return Response(serializer.data)
    #
    # def retrieve(self, request, pk):
    #     instance = Venue.objects.get(pk=pk)
    #     serializer = VenueSerializer(instance)
    #     return Response(serializer.data)

    @action(methods=['get'], detail=True)
    def discount(self, request, pk=None):
        venue = self.get_object()
        discounts = venue.discounts
        serializer = DiscountPointSerializer(discounts, many=True)
        return Response(serializer.data)
