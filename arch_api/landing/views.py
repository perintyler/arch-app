from django.shortcuts import render
from django.shortcuts import redirect
from .forms import NotificationForm
from pusher_push_notifications import PushNotifications
from django.http import HttpResponse
from django.contrib import admin
from django.contrib.auth.decorators import login_required
from api.models import Discount
from .forms import SignUpForm

from django.views.decorators.http import require_http_methods


def _getAPS(header, message):
    if header == None:
        return {"alert": message}
    return {"alert": {"title": header, "body": message}}


def send_notification(
    interests, message, badge=0, header=None, redirect=None, type=None
):
    PushNotifications(
        instance_id="a3bb9382-e554-4929-8b2a-bf4f728a67fa",
        secret_key="AAC3FEB358A597E2ADDEE4377DC3E03",
    ).publish(
        interests=interests,
        publish_body={
            "apns": {
                "aps": _getAPS(header, message),
                "data": {"redirect": redirect, "badge": badge, "type": type},
            }
        },
    )


def megaphone(request):
    if request.method == "POST":
        form = NotificationForm(request.POST)
        if form.is_valid():
            send_notification(
                [form.data["target"]], form.data["body"], header=form.data["header"]
            )
            return render(request, "megaphone.html", {"result": "Success"})
        return render(request, "megaphone.html", {"result": "Failure"})
    else:
        form = NotificationForm()
        return render(request, "megaphone.html", {"form": form})


def login(request):
    form = SignUpForm()
    return render(request, "login.html", {"form": form})


@login_required
def vendor(request):
    if request.POST.get("deactivate"):
        Discount.objects.filter(id=int(request.POST.get("discountID"))).update(
            active=False
        )
    elif request.POST.get("activate"):
        Discount.objects.filter(id=int(request.POST.get("discountID"))).update(
            active=True
        )
    elif request.POST.get("delete"):
        # Discount.objects.filter(id=int(request.POST.get('discountID'))).delete()
        pass
    elif request.POST.get("edit"):
        curr = Discount.objects.filter(id=int(request.POST.get('discountID')))
    return redirect(promotions)


def promotions(request):
    return render(request, "vendor/promotions.html", {})


def analytics(request):
    return render(request, "vendor/analytics.html", {})

