# -*- coding: utf-8 -*-
import json
from . import host, request
from PyQt5.QtCore import QObject, pyqtSignal, pyqtSlot, QThread


class Preset(QObject):

    def __init__(self, engine):
        super(Preset, self).__init__()
        self.preset_list = {}
        self.request = None

        engine.rootContext().setContextProperty("preset", self)

    acquired = pyqtSignal()
    failed = pyqtSignal(str, arguments=['message'])

    @pyqtSlot(result=str)
    def host(self):
        return "http://%s" % host

    @pyqtSlot(str, result=str)
    def data(self, table):
        return json.dumps(self.preset_list.get(table, []))

    @pyqtSlot()
    def get_data(self, force=False):
        if force or not self.preset_list:
            self.request = RequestThread()
            self.request.acquired.connect(self.on_acquired)
            self.request.start()

    def on_acquired(self, data):
        self.preset_list = data

        if not self.preset_list:
            self.failed.emit(u"连接失败")
            return

        self.acquired.emit()


class RequestThread(QThread):

    acquired = pyqtSignal(dict)

    def __init__(self):
        super(RequestThread, self).__init__()

    def run(self):
        result = request('preset')
        self.acquired.emit(result if result else {})
