# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.shortcuts import render
from django.http import HttpResponse
from main import models


# Create your views here.
def index(request):
    html = request.path.split('/')[-1] if request.path.split('/')[-1] else 'index.html'
    return render(request, html)


def api(request):
    table = request.path.split('/')[-1]
    query = {'project': models.Project.all, 'entity': models.Entity.get}
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
