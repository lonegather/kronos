# -*- coding: utf-8 -*-
import json
import requests
from requests.exceptions import ConnectionError


def request(table, **filters):
    server = "http://localhost:8000/api"
    # server = "http://10.1.21.252:8880/api"
    url = "{server}/{table}?".format(**locals())
    for field in filters:
        url += '%s=%s&' % (field, filters[field])

    try:
        result = requests.get(url).text
        return json.loads(requests.get(url).text)
    except ConnectionError:
        return []
