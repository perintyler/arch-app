import requests
from api.models import mUser

app_id = "1774459862605658"
app_secret = "920679ebcad42d45d9985a5ea9a5ec5c"


def get_url(endpoint, query):
    uri = "https://graph.facebook.com/"
    return "{uri}{endpoint}?{query}".format(uri=uri, endpoint=endpoint, query=query)


def get_access_token():

    # get an access token to make api calls on behalf of users using app id/secret
    endpoint = "oauth/access_token"
    query = "grant_type=client_credentials&client_id={0}&client_secret={1}".format(
        app_id, app_secret
    )
    url = get_url(endpoint, query)

    # parse the response and get the access token from the json
    response = requests.get(url)
    return response.json()["access_token"]


def get_friends_for_user(facebookID, access_token, cursor=None):

    results_per_page = 500

    query = None
    if cursor == None:
        query = "limit={0}".format(results_per_page)
    else:
        query = "limit={0}&after={1}".format(results_per_page, cursor)
    endpoint = "{id}/friends".format(id=facebookID)

    url = get_url(endpoint, query)

    headers = {"Authorization": "Bearer {}".format(access_token)}
    response = requests.get(url, headers=headers).json()

    friend_objects = response["data"]
    if not friend_objects:
        return []
    else:
        fb_ids = [id for id in map(lambda friend: friend["id"], friend_objects)]
        next_page_cursor = response["paging"]["cursors"]["after"]
        return fb_ids + get_friends_for_user(facebookID, access_token, next_page_cursor)


def update_friends():
    # get facebook access token valid for all arch users
    access_token = get_access_token()
    for user in mUser.objects.all():
        friend_fb_ids = get_friends_for_user(user.facebookID, access_token)
        updated_friends_qs = mUser.objects.filter(facebookID__in=friend_fb_ids)
        user.friends.set(updated_friends_qs)


def get_user_information(facebookID, fields):
    access_token = get_access_token()
    endpoint = "{id}".format(id=facebookID)
    if len(fields) != 0:
        s = "fields="
        for field in fields:
            s += field + ","
    print(s)
    url = get_url(endpoint, s if s else "")
    headers = {"Authorization": "Bearer {}".format(access_token)}
    return requests.get(url, headers=headers).json()

def get_gender(facebookID):
    response = get_user_information(facebookID, ["gender"])
    try:
        return response["gender"]
    except:
        return "error"

def get_age_range(facebookID):
    response = response = get_user_information(facebookID, ["age_range"])
    try:
        return response["age-range"]
    except:
        return "error"
