# import functools
#
# class Util:
#
#     '''
#     Standard map function that takes a list to iterate over and a function used to map
#     each element. This function operates like and uses the built in map function, but
#     returns the result as a list, instead of a map object.
#     '''
#     @staticmethod
#     def map(func,list):
#         return Util.map_to_list(map(lambda el: func(el),list))
#
#     '''wrapper for the functools reduce function'''
#     @staticmethod
#     def reduce(func,list,head):
#         return functools.reduce(func,list,head)
#
#     '''
#     This method takes a map object as input and returns it as a list. Since
#     map objects are iterable, this can be done by iterating through the map and
#     adding every element to a new list
#     '''
#     @staticmethod
#     def map_to_list(map):
#         return [el for el in map]
#
#     '''
#     Iterates over the given list and passes each element into the given function.
#     The useful thing about this function is it also returns the list which can be
#     used for functional programming techniques.
#     '''
#     @staticmethod
#     def iterate(func,list):
#         for el in list:
#             func(el)
#         return list
#
#     '''
#     Iterates over the given list and passes each element into the given function.
#     '''
#     @staticmethod
#     def foreach(func,list):
#         for el in list:
#             func(el)
#
#     '''
#     Takes a 2d list as input and returns the all the list elements combined into one
#     list e.g. [ [1, 2, 3], [4], [5, 6] ] -> [1, 2, 3, 4, 5, 6]
#     '''
#     @staticmethod
#     def collapse(list):
#         return reduce(lambda collapsed, el: collapsed.extend(el),list)
#
#
#     '''Simply assigns a value to a key in a dictionary. This can be used to assign values in lambda functions   '''
#     @staticmethod
#     def assign(dictionary,key,value):
#         dictionary[key] = value
