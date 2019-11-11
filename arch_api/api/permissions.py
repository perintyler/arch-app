from rest_framework.permissions import BasePermission


class EventCreatorPermission(BasePermission):
    message = 'You must be the creator of the event to perform this action.'

    def has_object_permission(self, request, view, event):
        return event.creator.pk != request.user.m_user.pk
