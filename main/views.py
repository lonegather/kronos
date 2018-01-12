# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.shortcuts import render
from django.http import HttpResponse
from main import models


# Create your views here.
def index(request):
    return render(request, 'index.html')


def front(request, url):
    return render(request, '%s.html' % url)


def api(request):
    table = request.path.split('/')[-1]
    query = {'project': models.Project.all,
             'entity': models.Entity.get,
             'stage': models.Stage.get,
             }
    flt = {}
    for key in request.GET:
        flt[key] = request.GET[key]
    return HttpResponse(query[table](**flt))


def ws(request):
    import uwsgi
    uwsgi.websocket_handshake()
    while True:
        msg = uwsgi.websocket_recv()
        uwsgi.websocket_send(msg)
