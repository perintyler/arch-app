import datetime
# Imports the Google Cloud client library
import firebase_admin
from firebase_admin import credentials
from firebase_admin import storage


# Instantiates a client
storage_client = storage.Client("arch")

cred = credentials.Certificate('path/to/serviceAccountKey.json')
firebase_admin.initialize_app(cred, {
    'storageBucket': 'gs://arch-b83e2.appspot.com'
})

bucket = storage.bucket()

def get_event_image(eventID):

    blob = bucket.blob("event/{eventID}".format(eventID))

    if blob.exists():
        url_expiration_date = datetime.datetime.now() + datetime.timedelta(minutes = 10)
        url = blob.generate_signed_url(url_expiration_date)
        return (url, True)
    else:
        return ("", False)
