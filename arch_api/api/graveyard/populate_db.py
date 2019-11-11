# from django.core.management.base import BaseCommand, CommandError
# from api.extras.Factory import Factory
# from api.models import Venue
#
# class Command(BaseCommand):
#     help = 'populates the db with mock data'
#
#     def handle(self, *args, **options):
#
#         users = Factory.User.create()
#         squads = Factory.Squad.create(users)
#         venues = Factory.Venue.create()
#         events = Factory.Event.create(users,venues)
#         drinks = Factory.Drink.create(venues)
#         discounts = Factory.DiscountPoint.create(venues)
#         discounts = Factory.DiscountPoint.create(discounts)
