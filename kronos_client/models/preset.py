# -*- coding: utf-8 -*-
import json
from . import request
from PyQt5.QtCore import QObject, pyqtSignal, pyqtSlot, QThread


class Preset(QObject):

    def __init__(self):
        super(Preset, self).__init__()
        self.preset_list = {}
        self.request = None

    acquired = pyqtSignal()
    failed = pyqtSignal(str, arguments=['message'])

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
        self.acquired.emit(request('preset'))
