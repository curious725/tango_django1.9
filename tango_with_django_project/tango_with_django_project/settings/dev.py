"""Development settings and globals."""
from .base import *

# DEBUG CONFIGURATION
DEBUG = True

ALLOWED_HOSTS = get_secret("dev_allowed_hosts")
