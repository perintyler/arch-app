from django.core.management.base import BaseCommand, CommandError
from api.extras import Facebook

class Command(BaseCommand):
    help = 'populates the db with mock data'

    def handle(self, *args, **options):
        Facebook.update_friends()
        # for user in mUser.objects.all():
        #     if user.facebookID != None:
        #         token = "" #TODO
        #         graph = facebook.GraphAPI(access_token=token, version="2.12")
        #         friendObjects = graph.get_connections(id='me', connection_name='friends')
        #         friend_fb_ids = map(lambda friend: friendObj['id'], friendObjects)
        #         friend_queryset = mUser.objects.filter(facebookID__in=friend_fb_ids)
        #         user.friends.set(friend_queryset)
