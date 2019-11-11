import firebase_admin,os.path
from firebase_admin import auth,credentials
from api.models import mUser
from django.conf import settings
from rest_framework import status
from rest_framework.response import Response
from django.contrib.auth import login
from django.contrib.auth.models import User
from api.extras import Facebook

cred = credentials.Certificate(os.path.join(settings.BASE_DIR,"arch_api/serviceAccount.json"))
firebase_admin.initialize_app(cred)

class FirebaseAuthMiddleware:

    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):

        if "HTTP_AUTHORIZATION" in request.META:

            auth_header = request.META["HTTP_AUTHORIZATION"]

            # check if it is properly formed
            if (auth_header.startswith("Bearer ")):

                firebase_token = auth_header.split("Bearer ")[1]
                decoded_token = None

                # validate token
                try:
                    decoded_token = auth.verify_id_token(firebase_token)
                except ValueError as e:
                    # this can be a lot of different errors, mostly if the token is expired/invalid. shouldn't happen if you
                    # generate the token correctly
                    print(e)


                # get user info from firebase
                if decoded_token is not None:

                    firebase_id_from_token = decoded_token["uid"]

                    muser_query = mUser.objects.filter(firebaseID=firebase_id_from_token)
                    if muser_query.exists():
                        existing_muser = muser_query.get(firebaseID=firebase_id_from_token)
                        #associatedUser, new_user = User.objects.get_or_create(email=firebase_user.email, username=firebase_user.uid)

                        request.user = existing_muser.user
                    else:
                        firebase_user = auth.get_user(firebase_id_from_token)
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
                                user_fields["facebookID"] = provider_data["rawId"]

                        # create the associate user and save it
                        associatedUser = User(username=firebase_user.uid)
                        if firebase_user.email != None:
                            associatedUser.email = firebase_user.email
                        associatedUser.save()


                        # set firebaseID in mUser to match the firebase uid
                        user_fields["firebaseID"] = firebase_user.uid
                        #set the user in mUser to match the created associated user
                        user_fields["user"] = associatedUser

                        # create the new mUser
                        new_muser = mUser.objects.create(**user_fields)

                        access_token = Facebook.get_access_token()
                        friend_fb_ids = Facebook.get_friends_for_user(new_muser.facebookID, access_token)
                        friends = mUser.objects.filter(facebookID__in=friend_fb_ids)
                        if friends.exists():
                            for friend in friends.all():
                                new_muser.friends.add(friend)
                                # TODO this seems weird. should friends be a foreign key?
                                friend.friends.add(new_muser)
                                friend.save()
                            new_muser.save()

                        new_muser._isNewUser = True

                        request.user = new_muser.user

        # let the rest of the middleware do their thing
        # here you would not call the next line if you wanted to only allow firebase auth, or if you wanted
        # to break the middleware chain
        # response = self.get_response(request)

        # return the value from the rest of the middleware if valid firebase user is set
        return self.get_response(request)
