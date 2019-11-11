from django import forms

class NotificationForm(forms.Form):
    target = forms.CharField(widget=forms.TextInput())
    header = forms.CharField(widget=forms.TextInput())
    body = forms.CharField(widget=forms.TextInput())

class SignUpForm(forms.ModelForm):
    username = forms.CharField(widget=forms.TextInput())
    password = forms.CharField(widget=forms.PasswordInput())
    next = forms.CharField(widget=forms.HiddenInput())
