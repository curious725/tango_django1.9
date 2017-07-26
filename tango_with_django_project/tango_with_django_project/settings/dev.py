"""Development settings and globals."""
from .base import *

# DEBUG CONFIGURATION
DEBUG = True

ALLOWED_HOSTS = get_secret("dev_allowed_hosts")


MIDDLEWARE_CLASSES += ['debug_toolbar.middleware.DebugToolbarMiddleware', ]
INSTALLED_APPS += ['debug_toolbar', ]

INTERNAL_IPS = get_secret("django_debug_toolbar_internal_ips")


DEBUG_TOOLBAR_CONFIG = {
    'DISABLE_PANELS': [
        'debug_toolbar.panels.redirects.RedirectsPanel',
    ],
    'SHOW_TEMPLATE_CONTEXT': True,
}
