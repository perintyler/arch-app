# from api.extras.Util import Util
#
# class DBUtil:
#
#     '''Adds a list of elements to a django collection'''
#     @staticmethod
#     def add_all(collection,elements):
#         return Util.foreach(lambda el: collection.add(el), elements)
#
#
#     '''
#     Saves every instance in the given list to the database.
#     '''
#     @staticmethod
#     def save_all(list):
#         return Util.iterate(lambda instance: instance.save(),list)
#
#
#     @staticmethod
#     def save_and_get(instance):
#         instance.save()
#         return instance
#
#     '''Takes a query set and returns a list containing each instance of the query set'''
#     @staticmethod
#     def to_list(querySet):
#         return [instance for instance in querySet]
#
#     class Week:
#
#         '''Takes a list of length 6 of booleans representing if a day the respective day is active'''
#         @staticmethod
#         def parse_string(days):
#             return Week(monday = days[0], tuesday = days[1], wednesday = days[2], thursday = days[3], friday = days[4], saturday = days[5])
