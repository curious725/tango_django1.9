from django.conf.urls import url

from . import views

app_name = 'rango'
urlpatterns = [
    # ex. /rango
    url('^$', views.index, name='index'),
    # ex. /rango/about
    url('^about/$', views.about, name='about'),
    # ex. /rango/add_category
    url('^add_category/$', views.add_category, name='add_category'),
    # ex. /rango/category/python
    url('^category/(?P<category_name_slug>[\w\-]+)/$',
        views.show_category, name='show_category'),

]
