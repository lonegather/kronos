# -*- coding: utf-8 -*-
from PyQt5.QtCore import QSize, QObject
from PyQt5.QtGui import QGuiApplication, QImage
from PyQt5.QtQuick import QQuickImageProvider


class ScreenShotProvider(QQuickImageProvider):

    def __init__(self):
        super(ScreenShotProvider, self).__init__(QQuickImageProvider.Image)
        self.clipboard = QGuiApplication.clipboard()
        self.clipboard.dataChanged.connect(self.on_changed)
        self.image = QImage(128, 128, QImage.Format_RGB32)
        self.image.fill(1)

    def on_changed(self):
        data = self.clipboard.mimeData()
        if data.hasImage():
            self.image = data.imageData()

    def requestImage(self, cmd, size):
        if not cmd:
            self.image.fill(1)
        if cmd.count("save"):
            print(cmd)
        return self.image, QSize(128, 128)
