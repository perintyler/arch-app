# from api.extras.DBUtil import DBUtil
# from api.extras.Util import Util
# from api.extras.Random import Random
# from api.models import mUser, Squad, Venue, DiscountPoint, DiscountPoint, Event
# from api.extras import dbdata
# import datetime
#
# '''
# This class can be used to populate the database using a mix of random and hard coded data. The
# generated data can be used to temporarily populate the database for testing. Models currently included are:
#     - mUser
#     - Squad
#     - Venue
#     - DiscountPoint
#     - DiscountPoint Point
#     - Drink
# '''
#
# class Factory:
#
#     class User:
#
#         @staticmethod
#         def create():
#             KEY_DIGITS = 10 #amount of digits to be generated for each user's facebook id field
#             return DBUtil.save_all(Util.map(lambda name: mUser(
#                                                             facebookID = Random.key(KEY_DIGITS),
#                                                             name = name,
#                                                             email = '{0}@email.com'.format(name),
#                                                             firebaseID = Random.key(KEY_DIGITS),
#                                                             image = "http://example.com/path",
#                                                             gender = Random.bool()
#                                                         ), dbdata.names))
#
#     class Squad:
#
#         '''Randomly adds the created squads to the list of users'''
#         @staticmethod
#         def create(users):
#             squad_names = dbdata.words
#             imageLocation = lambda squad_name: 'http://s3.arch/example-bucket/images/{0}'.format(squad_name)
#             squads = DBUtil.save_all(Util.map(lambda squadName: Squad(name = squadName, image = imageLocation(squadName)), squad_names))
#             Util.foreach(lambda user: DBUtil.add_all(user.squads, Random.subarray(squads)), users)
#             return squads
#
#     class Venue:
#
#         @staticmethod
#         def create():
#             return DBUtil.save_all(Util.map(lambda venueData: Venue( \
#                                                                 name = venueData['name'],
#                                                                 description = venueData['description'],
#                                                                 address = venueData['address'],
#                                                                 city = venueData['city'],
#                                                                 zip = venueData['zip'],
#                                                                 image = venueData['img'],
#                                                                 state = venueData['state'],
#                                                                 lat = 432.2,
#                                                                 long = 32.2
#                                                             ), dbdata.venues))
#
#     class Event:
#
#         @staticmethod
#         def create(users, venues):
#             a,b = Factory.Event._split(users)
#             events = []
#             for _ in range(10):
#                 invited = Random.subarray(a)
#                 attending = Random.subarray(b)
#                 creator = attending[0]
#                 date = datetime.date(2017, 8, 20)
#                 description = "sdiuhfosidhfiushdoifhoishoihsdoifhosidhfoishdoifhoishd"
#                 venue = Random.element(venues)
#                 image = "https://tinyurl.com/y7z6g9or"
#                 name = "event name suhfd ios"
#                 event = Event(creator=creator,date=date,description=description,venue=venue,image=image,name=name)
#                 event.save()
#                 for user in invited:
#                     event.invited.add(user)
#                 for user in attending:
#                     event.attending.add(user)
#             return events
#
#         @staticmethod
#         def _split(list):
#             half = int(len(list)/2)
#             return list[:half], list[half:]
#
#     class DiscountPoint:
#
#         @staticmethod
#         def create(venues):
#             random_discounts = lambda _: DBUtil.save_all([DiscountPoint(
#                                                     name = Random.element(dbdata.words),
#                                                     enabled = True,
#                                                     days = Factory.Week.create()
#                                                 ) for _ in range(Random.int(1,5))])
#             configured_discount = lambda discount, venue: Util.iterate(lambda discount: DBUtil.add_all(discount.drinks,Random.subarray(DBUtil.to_list(venue.drink_set.all()))),random_discounts(None))
#             return Util.reduce(lambda discounts, venue: discounts + configured_discount(discounts,venue), venues, [])
#
#     class DiscountPoint:
#
#         '''Creates and returns N amount of instances of the discount point model, using the given discount for its foreign key'''
#         @staticmethod
#         def create(discounts):
#             parse = lambda discountData, discount: DiscountPoint(
#                                                             type = discountData['type'],
#                                                             constant = Random.price() if discountData['constant'] else None,
#                                                             discount = discount,
#                                                             size = Random.element([i*5 for i in range(10)])
#                                                         )
#             random_dps = lambda discount: DBUtil.save_all(Util.map(lambda dpDatum: parse(dpDatum,discount), Random.subarray(dbdata.discounts)))
#
#             return Util.reduce(lambda dps, discount: dps + random_dps(discount),discounts,[])
