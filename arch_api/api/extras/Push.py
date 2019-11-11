from pusher_push_notifications import PushNotifications

def _getAPS(header, message):
    if header == None: return { 'alert': message }
    return {
        'alert': {
            'title': header,
            'body': message
        }
    }

def send_notification(interests, message, badge=0, header=None, redirect=None, type=None):
    PushNotifications(
        instance_id='a3bb9382-e554-4929-8b2a-bf4f728a67fa',
        secret_key='AAC3FEB358A597E2ADDEE4377DC3E03'
    ).publish(
        interests = interests,
        publish_body = {
            'apns': {
                'aps': _getAPS(header, message),
                'data': { 'redirect': redirect, 'badge': badge, 'type': type }
            }
        }
    )
