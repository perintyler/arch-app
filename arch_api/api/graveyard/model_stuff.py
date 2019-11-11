#
# """
# ### Profile
# """
# class Profile(models.Model):
#     # Extends built-in user model to add venue attribute
#     user = models.OneToOneField(User, on_delete=models.CASCADE)
#     venue = models.ForeignKey(Venue, on_delete=models.PROTECT, null=True, blank=True)
#
#     def __str__(self):
#         return self.user.username
#
#
#
# """
# ### Profile Functions
# """
# @receiver(post_save, sender=User)
# def create_user_profile(sender, instance, created, **kwargs):
#     if created:
#         temp_venue = Venue.objects.last() # TODO: get an actual venue ID
#         Profile.objects.create(user=instance, venue=temp_venue)
#
#
# @receiver(post_save, sender=User)
# def save_user_profile(sender, instance, **kwargs):
#     try:
#         instance.profile.save()
#     except:
#         temp_venue = Venue.objects.last() # TODO: get an actual venue ID
#         Profile.objects.create(user=instance, venue=temp_venue)
#
#
# """
# ### Message (unused back-end implementation for IM messaging)
# """
# class Message(models.Model):
#     content = models.CharField(max_length=255)
#     date = models.DateTimeField(auto_now=True)
#     sender = models.ForeignKey(mUser, on_delete=models.CASCADE)
#     event = models.ForeignKey(Event, on_delete=models.CASCADE, null=True)
