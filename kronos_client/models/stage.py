# -*- coding: utf-8 -*-
from PyQt5.QtCore import QObject, pyqtSignal, pyqtSlot, QThread
from . import request


class Stage(QObject):

    def __init__(self):
        super(Stage, self).__init__()
        self.stage_list = []
        self.request = None

    acquired = pyqtSignal()
    failed = pyqtSignal(str, arguments=['message'])

    @pyqtSlot(str, str, result=str)
    def data(self, name, field):
        for stg in self.stage_list:
            if stg['name'] == name:
                return stg[field]
        return ''

    @pyqtSlot()
    def get_data(self, force=False):
        if force or not self.stage_list:
            self.request = RequestThread()
            self.request.acquired.connect(self.on_acquired)
            self.request.start()

    def on_acquired(self, data):
        self.stage_list = data

        if not self.stage_list:
            self.failed.emit(u"连接失败")
            return

        self.acquired.emit()


class RequestThread(QThread):

    acquired = pyqtSignal(list)

    def __init__(self):
        super(RequestThread, self).__init__()

    def run(self):
        self.acquired.emit(request('stage'))
