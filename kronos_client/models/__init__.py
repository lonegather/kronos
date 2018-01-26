# -*- coding: utf-8 -*-
import json
import requests
from requests.exceptions import ConnectionError

host = "localhost:8000"
# host = "10.1.21.252:8880"


def request(table, **filters):
    server = "http://%s/api" % host
    url = "{server}/{table}?".format(**locals())
    for field in filters:
        url += '%s=%s&' % (field, filters[field])

    try:
        return json.loads(requests.get(url).text)
    except ConnectionError:
        return []


def commit(table, **fields):
    server = "http://%s/api" % host
    url = "{server}/{table}".format(**locals())
    kwargs = {'data': {}}
    for field in fields:
        if field == 'file':
            kwargs['files'] = fields[field]
        else:
            kwargs['data'][field] = fields[field]

    try:
        requests.post(url, **kwargs)
        return True
    except ConnectionError:
        return False
