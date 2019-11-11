from django import template
from api.models import Discount, Transaction
from api.extras import Facebook
from collections import Counter

register = template.Library()


@register.inclusion_tag("vendor/discount_table.html")
def currentDiscounts(venue):
    return {"discounts": venue.discounts.filter(active=True)}


@register.inclusion_tag("vendor/discount_table.html")
def inactiveDiscounts(venue):
    return {"discounts": venue.discounts.filter(active=False)}


@register.inclusion_tag("vendor/modal_edit.html")
def modalEdit(venue):
    return {"discounts": venue.discounts.all()}


@register.inclusion_tag("vendor/simple_text.html")
def getNumUsers(venue):
    a = set()
    for e in venue.events.all():
        for u in e.attending.all():
            a.add(u)
    c = len(a)
    return {"text": c}


@register.inclusion_tag("vendor/simple_text.html")
def getNumClaims(venue):
    c = Transaction.objects.filter(event__in=venue.events.all()).count()
    return {"text": c}


@register.inclusion_tag("vendor/graph.html")
def getGenders(venue):
    # a = set()
    # for e in venue.events.all():
    #     for u in e.attending.all():
    #         a.add(u)
    # g = []
    # for u in a:
    #     g.append(Facebook.get_gender(u.facebookID))
    # c = Counter(g)
    g = {'male': 33, 'female': 11, 'other': 2}
    return {"g": g}

@register.inclusion_tag("vendor/graph.html")
def getAges(venue):
    g = {'18 to 21': 24, '22 to 25': 10, '25 to 28': 8, '29+': 4}
    return {"g": g}