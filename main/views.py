# -*- coding: utf-8 -*-
from __future__ import unicode_literals

import json
from django.shortcuts import render
from main import models
from django.http import HttpResponse


# Create your views here.
def repo(request):
    return render(request, 'repo.html', {'string': str(get_projects())})


def api(request):
    return HttpResponse(str(get_projects()))


def get_projects():
    result = []
    for prj in models.Project.objects.all():
        if prj.name == '|': continue
        result.append({'name':prj.name, 'info':prj.info, 'url':prj.url})
    return json.dumps(result)