# -*- coding: utf-8 -*-

import threading


class Client(threading.Thread):

    def __init__(self):
        super(Client, self).__init__()

    def run(self):
        import uwsgi
        import time

        uwsgi.websocket_handshake()
        while True:
            msg = uwsgi.websocket_recv()
            uwsgi.websocket_send("[%s] %s" % (time.time(), msg))
