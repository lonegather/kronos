# -*- coding: utf-8 -*-
from __future__ import unicode_literals

import json
from channels import Group
from django.shortcuts import render
from django.http import HttpResponse
from django.contrib.auth import authenticate, login, logout
from main import models


# Create your views here.
def index(request):
    return render(request, 'index.html')


def front(request, url):
    return render(request, '%s.html' % url)


def auth(request):
    response = {}
    username = request.POST['username']
    password = request.POST['password']
    user = authenticate(request, username=username, password=password)
    if user is not None:
        login(request, user)
        response['session'] = request.session.session_key
        response['name'] = user.username
        response['info'] = user.profile.name
        response['role'] = user.profile.role.name
        response['department'] = user.profile.department.name

    return HttpResponse(json.dumps(response))


def api(request):
    table = request.path.split('/')[-1]
    if request.method == 'GET':
        return api_get(request, table)
    elif request.method == 'POST':
        return api_set(request, table)


def api_get(request, table):
    flt = {}
    query_dict = {
        'preset': lambda **__: {
            "project": models.Project.all(),
            "stage": models.Stage.get(),
            "tag": models.Tag.get(),
            "batch": models.Entity.get(genus='batch'),
        },
        'project': models.Project.all,
        'entity': models.Entity.get,
        'stage': models.Stage.get,
    }
    for key in request.GET:
        flt[key] = request.GET[key]
    return HttpResponse(json.dumps(query_dict[table](**flt)))


def api_set(request, table):
    form = dict(request.POST)
    modify_dict = {
        'entity': models.Entity.set,
    }
    if request.FILES:
        for f in request.FILES:
            form[f] = request.FILES[f]
    modify_dict[table](form)
    Group('global').send({'text': '%s changed' % form['name']})
    return HttpResponse("")
