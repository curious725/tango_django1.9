from django.conf.urls import url

from . import views

app_name = 'rango'
urlpatterns = [
    # ex. /rango
    url('^$', views.index, name='index'),

]
