from __future__ import unicode_literals

from django.db import models


class Category(models.Model):
    name = models.CharField(max_length=128, unique=True)

    def __unicode__(self):  # for Python 3, use __str__
        return self.name
