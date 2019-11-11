from django.urls import path
from django.contrib.auth import views as auth_views
from django.views.generic import TemplateView

from landing import views

urlpatterns = [
    path('', TemplateView.as_view(template_name='index.html'), name='index'),
    path('login/', auth_views.LoginView.as_view(template_name='authentication/login.html'), name='login'),
    path('reset-password/', TemplateView.as_view(template_name='authentication/password_reset.html'), name='reset-password'),
    path('policy/', TemplateView.as_view(template_name='privacy_policy.html'), name='privacy_policy'),
    path('vendor/', views.vendor, name='vendor'),
    path('vendor/promotions', views.promotions, name='promotions'),
    path('vendor/analytics', views.analytics, name='analytics'),
    path('megaphone/', views.megaphone, name='megaphone'),
]
