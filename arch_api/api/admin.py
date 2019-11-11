from django.contrib import admin
from api.models import *

# Register your models here.
admin.site.register(mUser)
admin.site.register(Venue)
admin.site.register(Event)
# admin.site.register(DiscountPoint)
# admin.site.register(DiscountPointPoint)
admin.site.register(Discount)
admin.site.register(Notification)
admin.site.register(Action)
admin.site.register(Transaction)
