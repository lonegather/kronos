# -*- coding: utf-8 -*-
import json
import requests
from requests.exceptions import ConnectionError

address = "http://localhost:8000/api"
# address = "http://10.1.21.252:8880/api"


def request(table, **filters):
    server = address
    url = "{server}/{table}?".format(**locals())
    for field in filters:
        url += '%s=%s&' % (field, filters[field])

    try:
        return json.loads(requests.get(url).text)
    except ConnectionError:
        return []


def commit(table, **fields):
    server = address
    url = "{server}/{table}".format(**locals())
    try:
        requests.post(url, data=fields)
        return True
    except ConnectionError:
        return False
