from api.views.venue_views import VenueViewSet
from api.views.user_views import UserViewSet, FriendViewSet
from api.views.event_views import EventViewSet
from api.views.notification_views import NotificationViewSet
from api.views.action_views import ActionViewSet
from django.conf.urls import url, include
from rest_framework import routers


#configure router and register all neccessary view sets to the router
router = routers.DefaultRouter()

router.register(r'venue', VenueViewSet, base_name='venue')
router.register(r'event', EventViewSet, base_name='event')
router.register(r'notification', NotificationViewSet, base_name='notification')
router.register(r'action', ActionViewSet, base_name='action')
router.register(r'user', UserViewSet, base_name='user')
router.register(r'friends', FriendViewSet, base_name='friends')



urlpatterns = [
    url(r'^', include(router.urls)), #automatically includes all registered view sets
    url(r'^api-auth/', include('rest_framework.urls', namespace='rest_framework')),
]
