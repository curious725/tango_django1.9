"""Production settings and globals."""
from .base import *



ALLOWED_HOSTS = get_secret("prod_allowed_hosts")
