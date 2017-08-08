from django.conf.urls import url

from . import views

app_name = 'rango'
urlpatterns = [
    # ex. /rango
    url('^$', views.index, name='index'),
    # ex. /rango/register
    url('^register/$', views.register, name='register'),
    # ex. /rango/login
    url('^login/$', views.user_login, name='login'),
    # ex. /rango/logout
    url('^logout/$', views.user_logout, name='logout'),
    # ex. /rango/about
    url('^about/$', views.about, name='about'),
    # ex. /rango/add_category
    url('^add_category/$', views.add_category, name='add_category'),
    # ex. /rango/category/python
    url('^category/(?P<category_name_slug>[\w\-]+)/$',
        views.show_category, name='show_category'),
    # ex. /rango/category/python/add_page
    url('^category/(?P<category_name_slug>[\w\-]+)/add_page/$',
        views.add_page, name='add_page'),
    # ex. /rango/restricted
    url('^restricted/$', views.restricted, name='restricted'),
]
