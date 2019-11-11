from django.db import models
import re
from django.contrib.auth.models import User
from django.db.models.signals import post_save
from django.dispatch import receiver

"""
TODO:
    Remove Discount point and just make it discount
    add related names to all foreign keys (discount_set -> discounts)
"""

"""
### User
"""
class mUser(models.Model):

    name = models.CharField(max_length=255)
    facebookID = models.CharField(max_length=255)
    firebaseID = models.CharField(max_length=255)
    pushToken = models.CharField(max_length=255, null=True)
    user = models.OneToOneField(User, related_name='m_user', on_delete=models.CASCADE, null=True)
    friends = models.ManyToManyField("mUser")

    @property
    def is_new_user(self):
        return False if self._isNewUser == None else self._isNewUser

    def __str__(self):
        return self.name

    # using a property here since there was already 90+ mUsers without the user field
    # this can eventually be removed
    @property
    def create_and_get_user(self):
        # check if the user field is null and create one if so
        self._isNewUser = True
        associatedUser, alreadyExists = User.objects.get_or_create(email=self._email,username=self.firebaseID)
        self.user = associatedUser
        self.save()
        return self.user

"""
### Venue
"""
class Venue(models.Model):

    name = models.CharField(max_length=255)
    image = models.CharField(max_length=255)
    desc = models.TextField(blank=True)
    address = models.CharField(max_length=255)
    city = models.CharField(max_length=255)
    zip = models.CharField(max_length=255)
    state = models.CharField(max_length=255)
    owners = models.ManyToManyField(User, related_name="venues", blank=True)

    def __str__(self):
        return self.name



"""
### Discount Point
"""
class Discount(models.Model):

    size = models.IntegerField()
    type = models.CharField(max_length=255)
    constant = models.IntegerField(null=True, blank=True)
    single_use = models.BooleanField(default=False)
    venue = models.ForeignKey(Venue, null=True, related_name='discounts', on_delete=models.CASCADE)
    active = models.BooleanField(default=True)

    @property
    def text(self):
        if (self.constant == None): return self.type
        else: return re.sub(r'\*', str(self.constant), self.type)

    @property
    def tag_color(self):
        return {
            '*% off': 'orange',
            'Free Shot': 'blue',
        }[self.type]

    def __str__(self):
        return (self.venue.name + ", " + self.type) 


"""
### Event
"""
class Event(models.Model):

    name = models.CharField(max_length=255)
    has_image = models.BooleanField()
    desc = models.TextField(null=True)
    date = models.DateField()
    dateCreated = models.DateTimeField(auto_now=True)
    expired = models.BooleanField(default=False)
    creator = models.ForeignKey(mUser, related_name="created_events", null=True, on_delete=models.CASCADE)
    venue = models.ForeignKey(Venue, related_name="events", null=True, on_delete=models.CASCADE)
    attending = models.ManyToManyField(mUser, related_name="attending")
    checkedIn = models.ManyToManyField(mUser, related_name="checkedIn")


"""
### Notification
"""
class Notification(models.Model):

    date = models.DateTimeField(auto_now_add=True)
    viewed = models.BooleanField(default=False)
    user = models.ForeignKey(mUser, related_name='notifications', on_delete=models.CASCADE) # mUser instead of User? kept cause I'm sure it means something to you texas
    inviter = models.ForeignKey(mUser, related_name='sent_invites', on_delete=models.CASCADE)
    event = models.ForeignKey(Event, related_name='notifications', on_delete=models.CASCADE)

    class Meta:
        unique_together = ('user', 'event')


"""
### Transaction (used to track user discount claims)
"""
class Transaction(models.Model):

    date = models.DateTimeField(auto_now_add=True)
    user = models.ForeignKey(mUser, related_name='transactions', on_delete=models.CASCADE)
    event = models.ForeignKey(Event, related_name='transactions', on_delete=models.CASCADE)
    discount = models.ForeignKey(Discount, related_name='transactions', on_delete=models.CASCADE)


"""
### Action (used for stream)
"""
class Action(models.Model):

    user = models.ForeignKey(mUser, related_name="actions", on_delete=models.CASCADE)
    event = models.ForeignKey(Event, related_name="actions", on_delete=models.CASCADE)
