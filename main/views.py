# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.shortcuts import render
from django.http import HttpResponse
from django.contrib.auth import authenticate, login, logout
from main import models, sockets


# Create your views here.
def index(request):
    return render(request, 'index.html')


def front(request, url):
    return render(request, '%s.html' % url)


def auth(request):
    username = request.POST['username']
    password = request.POST['password']
    user = authenticate(request, username=username, password=password)
    if user is not None:
        login(request, user)
        return HttpResponse("success")
    else:
        pass


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
