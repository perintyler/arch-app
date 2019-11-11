from django.core.management.base import BaseCommand, CommandError
from api.models import Venue, Discount

venues = [
    {
        'name': 'The Olive Bar',
        'address': '3037 Olive St.',
        'city': 'St. Louis',
        'desc': "Located in downtown St. Louis in Midtown. Featuring a rooftop patio, multiple floors, the best drinks and hottest night life in St. Louis.",
        'image': 'https://firebasestorage.googleapis.com/v0/b/arch-b83e2.appspot.com/o/venue%2Folive_bar.png?alt=media&token=2835db81-12cf-4839-b9bc-d4a8e5c05881',
        'state': 'MO',
        'zip': 63103,
    }, {
        'name': "Big Daddy's on The Landing",
        'address': '118 Morgan St',
        'city': 'St. Louis',
        'desc': "Host your pre-game, watch party, or post-game celebration at Big Daddy's on the Landing",
        'image': 'https://firebasestorage.googleapis.com/v0/b/arch-b83e2.appspot.com/o/venue%2Fbig_daddys.jpg?alt=media&token=7acd96fd-93d0-49db-96d3-4f608df859ce',
        'state': 'MO',
        'zip': 63102,
    }, {
        'name': 'Wheelhouse Downtown',
        'address': '1000 Spruce St.',
        'city': 'St. Louis',
        'desc': "Lofty, industrial hangout with 2 bars & creative pub grub, plus weekend brunch & TVs showing sports.",
        'image': 'https://firebasestorage.googleapis.com/v0/b/arch-b83e2.appspot.com/o/venue%2Fwheelhouse.jpg?alt=media&token=00da1efb-bbe2-4602-89b9-a2fa13a69e0d',
        'state': 'MO',
        'zip': 63102,
    }, {
        'name': 'Marquee Restaurant',
        'address': '1911 Locust St.',
        'city': 'St. Louis',
        'desc': 'Sleek nightspot in airy, mod digs with a full bar, 30 video screens & inventive pub grub.',
        'image': 'https://firebasestorage.googleapis.com/v0/b/arch-b83e2.appspot.com/o/venue%2Fmarquee.jpg?alt=media&token=381a2705-5c33-4113-8552-10994306ac71',
        'state': 'MO',
        'zip': 63103,
    }, {
        'name': 'Start Bar',
        'address': '1000 Spruce St, St. Louis',
        'city': 'St. Louis',
        'desc': 'Upbeat watering hole with quirky cocktails & bar snacks, plus lots of classic arcade games.',
        'image': 'https://firebasestorage.googleapis.com/v0/b/arch-b83e2.appspot.com/o/venue%2Fstartbar0image.jpg?alt=media&token=5a973896-7907-4acf-b352-5e92e9dc16f0',
        'state': 'MO',
        'zip': 63102,
    }, {
        'name': 'Lucas Park Grill',
        'address': '1234 Washington Ave',
        'city': 'St. Louis',
        'desc': 'American large & small plates in an updated-industrial lounge & dining room with three fireplaces.',
        'image': 'https://firebasestorage.googleapis.com/v0/b/arch-b83e2.appspot.com/o/venue%2Flpg-image.png?alt=media&token=6b8aba14-2915-4a1b-b8a9-825a4ec30156',
        'state': 'MO',
        'zip': 63103,
    }, {
        'name': "Mike Duffy's Pub & Grill",
        'address': ' 6662 Clayton Rd',
        'city': 'St. Louis',
        'desc': 'Convivial neighborhood hangout with craft brew, a pub-grub menu & sports on TV, plus happy hour.',
        'image': 'https://firebasestorage.googleapis.com/v0/b/arch-b83e2.appspot.com/o/venue%2Fduffys-image.jpg?alt=media&token=94a8a0c6-b04b-477e-a919-6fb09228b482',
        'state': 'MO',
        'zip': 63117,
    }, {
        'name': 'Europe Night Club',
        'address': '710 N 15th St',
        'city': 'St. Louis',
        'desc': 'Electronic house music club staging national & international acts, Friday & Saturday nights only.',
        'image': 'https://firebasestorage.googleapis.com/v0/b/arch-b83e2.appspot.com/o/venue%2Fclub_europe.jpg?alt=media&token=7b439ce1-1367-4ac9-b7c8-a23efede9495',
        'state': 'MO',
        'zip': 63117,
    }, {
        'name': 'Tin Roof',
        'address': '1000 Clark Ave',
        'city': 'St. Louis',
        'desc': 'Buzzing watering hole & live gig venue with beers on tap & Southern style bar food.',
        'image': 'https://firebasestorage.googleapis.com/v0/b/arch-b83e2.appspot.com/o/venue%2Ftinroof.jpg?alt=media&token=a1d796ea-b7cb-4fa7-a1ef-a97ace42a11a',
        'state': 'MO',
        'zip': '63102',
    }
]

discounts = {

    'The Olive Bar': [
        {'type': 'Free Shot', 'size': 10, 'single_use': True},
        {'type': '*% Off', 'size': 15, 'constant': 15},
    ],

    "Big Daddy's on The Landing": [
        {'type': '*% Off', 'size': 1, 'constant': 10},
        {'type': '*% Off', 'size': 10, 'constant': 15},
        {'type': '*% Off', 'size': 20, 'constant': 20},
    ],

    'Marquee Restaurant': [
        {'type': 'Free Shot', 'size': 10, 'single_use': True},
        {'type': '*% Off', 'size': 15, 'constant': 15},
    ],

    'Wheelhouse Downtown': [
        {'type': '*% Off', 'size': 5, 'constant': 15},
        {'type': '*% Off', 'size': 10, 'constant': 20},
        {'type': '*% Off', 'size': 15, 'constant': 25},
    ],

    'Start Bar': [
        {'type': '*% Off', 'size': 5, 'constant': 15},
        {'type': '*% Off', 'size': 10, 'constant': 20},
        {'type': '*% Off', 'size': 15, 'constant': 25},
    ],

    'Europe Night Club': [
        {'type': '*% Off', 'size': 5, 'constant': 15},
        {'type': '*% Off', 'size': 10, 'constant': 20},
        {'type': '*% Off', 'size': 15, 'constant': 25},
    ],

    "Mike Duffy's Pub & Grill": [
        {'type': '*% Off', 'size': 5, 'constant': 10},
        {'type': '*% Off', 'size': 10, 'constant': 15},
        {'type': '*% Off', 'size': 15, 'constant': 20},
    ],

    'Lucas Park Grill': [
        {'type': '*% Off', 'size': 1, 'constant': 10},
        {'type': '*% Off', 'size': 10, 'constant': 15},
    ],

    'Tin Roof': [
        {'type': '$* Domestics', 'size': 1, 'constant': 3},
        {'type': '$* Wells', 'size': 1, 'constant': 5},
        {'type': '*% Off', 'size': 10, 'constant': 10},
        {'type': '*% Off', 'size': 15, 'constant': 15},
    ],

}
class Command(BaseCommand):
    help = 'populates the db with mock data'

    def handle(self, *args, **options):

        # loop through venue data and create venue using the fields dictionary
        for venue in venues:
            new_venue = Venue.objects.create(**venue)
            discount_objs = discounts[new_venue.name]
            for discount_object in discount_objs:
                discount = Discount.objects.create(**discount_object)
                new_venue.discounts.add(discount)
