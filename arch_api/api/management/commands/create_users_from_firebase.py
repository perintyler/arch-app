from django.core.management.base import BaseCommand, CommandError
import firebase_admin,os.path
from firebase_admin import auth,credentials
from django.conf import settings
from api.models import mUser
from django.contrib.auth.models import User

class Command(BaseCommand):
    help = 'populates the db with mock data'

    def handle(self, *args, **options):
        cred = credentials.Certificate(os.path.join(settings.BASE_DIR,"arch_api/serviceAccount.json"))
        firebase_admin.initialize_app(cred)

        page = auth.list_users()
        while page:
            for user in page.users:
                user_query = mUser.objects.filter(firebaseID=user.uid)
                if not user_query.exists():
                    self.create_user(user   )
            # Get next batch of users.
            page = page.get_next_page()

    def create_user(self, firebase_user):
        user_fields = {}

        # check if it's a facebook firebase user
        if "providerUserInfo" in firebase_user._data.keys():
            provider_data = None
            #loop through all the auth providers to find facebook
            for info_for_provider in firebase_user._data["providerUserInfo"]:
                if info_for_provider["providerId"] == "facebook.com":
                    provider_data = info_for_provider
                    break
            if provider_data is not None:
                user_fields["name"] = provider_data["displayName"]
                user_fields["facebookID"] = provider_data["federatedId"]

        # create the associate user and save it
        associatedUser = User(email=firebase_user.email, username=firebase_user.uid)
        associatedUser.save()

        # set firebaseID in mUser to match the firebase uid
        user_fields["firebaseID"] = firebase_user.uid
        #set the user in mUser to match the created associated user
        user_fields["user"] = associatedUser

        # create the new mUser
        new_muser = mUser.objects.create(**user_fields)
