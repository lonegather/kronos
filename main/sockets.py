# -*- coding: utf-8 -*-

import threading


class Client(threading.Thread):

    clients = []

    @classmethod
    def create(cls):
        client = cls()
        cls.clients.append(client)
        client.start()

    def __init__(self):
        super(Client, self).__init__()

    def run(self):
        import uwsgi
        import time

        uwsgi.websocket_handshake()
        while True:
            msg = uwsgi.websocket_recv()
            print("Message from client: %s" % msg)
            if msg == "close":
                break
            uwsgi.websocket_send("[%s] %s" % (time.time(), msg))

        print("Client closed.")
        Client.clients.remove(self)
