# -*- coding: utf-8 -*-
import os
from PyQt5.QtCore import QSize, QObject, pyqtSignal, pyqtSlot
from PyQt5.QtGui import QGuiApplication, QImage
from PyQt5.QtQuick import QQuickImageProvider


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
