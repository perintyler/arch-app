# import random
# import string
#
# class Random:
#
#     '''Returns a random element in the given array'''
#     @staticmethod
#     def element(arr):
#         return arr[Random.int(0,len(arr)-1)]
#
#     '''Returns a random price i.e. a random float rounded to two decimal places'''
#     @staticmethod
#     def price():
#         min_price = 5
#         max_price = 20
#         return Random.float(min_price, max_price)
#
#     '''Returns a random int between a and b'''
#     @staticmethod
#     def int(a,b):
#         return random.randint(a,b)
#
#     '''
#     Returns a random float between a and b. The length parameter can be used to change the precision of rounding. When length is 2,
#     this function will return a float with 2 decimal places e.g. 2.32.
#     '''
#     @staticmethod
#     def float(a,b,length = 2):
#         return round(random.uniform(a,b),length)
#
#     '''Returns a sub-array of the given array containing a random amount of random values.'''
#     @staticmethod
#     def subarray(arr):
#         if(len(arr)==1):
#             return arr
#         size = Random.int(1,len(arr)-1)
#         random.shuffle(arr)
#         return arr[:size]
#
#     '''Returns a string of random digits of length N'''
#     @staticmethod
#     def key(N):
#         return ''.join(random.choices(string.ascii_uppercase + string.digits, k=N))
#
#
#     '''Pops and returns and element at a random index from the given list'''
#     @staticmethod
#     def pop(list):
#         return list.pop(Random.int(0,len(list)-1))
#
#
#     '''Randomly returns either true or false'''
#     @staticmethod
#     def bool():
#         return True if Random.int(0,1) == 1 else False
