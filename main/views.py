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
    query_dict = {'project': models.Project.all,
                  'entity': models.Entity.get,
                  'stage': models.Stage.get,
                  }
    query_list = {'entity_id': models.Entity.get_by_id,
                  }
    if table in query_dict:
        flt = {}
        for key in request.GET:
            flt[key] = request.GET[key]
        return HttpResponse(query_dict[table](**flt))
    elif table in query_list:
        return HttpResponse(query_list[table](request.GET['list']))
