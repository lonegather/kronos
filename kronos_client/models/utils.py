# -*- coding: utf-8 -*-
import os
import json
from PyQt5.QtCore import QSize, QObject, pyqtSignal, pyqtSlot, QThread
from PyQt5.QtGui import QGuiApplication, QImage
from PyQt5.QtQuick import QQuickImageProvider
from . import login


class Auth(QObject):

    granted = pyqtSignal()
    denied = pyqtSignal()

    def __init__(self, engine):
        super(Auth, self).__init__()
        self.thread = None
        self.session = ""
        self.name = ""

        engine.rootContext().setContextProperty("auth", self)

    @pyqtSlot(str, str)
    def login(self, username, password):
        self.thread = AuthThread(username, password)
        self.thread.accepted.connect(self.on_accepted)
        self.thread.start()

    @pyqtSlot(result=str)
    def session(self):
        return self.session

    @pyqtSlot(result=str)
    def name(self):
        return self.name

    @pyqtSlot(result=str)
    def level(self):
        pass

    def on_accepted(self, response):
        response = json.loads(response)
        if response:
            self.session = response['session']
            self.name = response['username']
            self.granted.emit()
        else:
            self.denied.emit()


class AuthThread(QThread):

    accepted = pyqtSignal(str)

    def __init__(self, username, password):
        super(AuthThread, self).__init__()
        self.username = username
        self.password = password

    def run(self):
        self.accepted.emit(login(self.username, self.password))


class ScreenShot(QObject):

    grabbed = pyqtSignal()

    def __init__(self, engine):
        super(ScreenShot, self).__init__()
        self.provider = ScreenShotProvider()
        self.clipboard = QGuiApplication.clipboard()
        self.clipboard.dataChanged.connect(self.on_changed)

        engine.addImageProvider("screenshot", self.provider)
        engine.rootContext().setContextProperty("screenshot", self)

    def on_changed(self):
        data = self.clipboard.mimeData()
        if data.hasImage():
            self.provider.image = data.imageData()
            self.grabbed.emit()

    @pyqtSlot()
    def clear(self):
        self.provider.image.fill(1)

    @pyqtSlot(str, result=str)
    def file(self, name):
        temp = os.getenv('TMP')
        file_path = '{temp}\\{name}.png'.format(**locals())
        self.provider.image.save(file_path)
        return file_path


class ScreenShotProvider(QQuickImageProvider):

    width = 128
    height = 128

    def __init__(self):
        super(ScreenShotProvider, self).__init__(QQuickImageProvider.Image)
        self.image = QImage(self.width, self.height, QImage.Format_RGB32)
        self.image.fill(1)

    def requestImage(self, *args, **kwargs):
        return self.image, QSize(self.width, self.height)
