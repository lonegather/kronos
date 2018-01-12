# -*- coding: utf-8 -*-
from PyQt5.QtCore import QObject, pyqtSignal, pyqtSlot, QThread
from . import request


class Project(QObject):

    def __init__(self):
        super(Project, self).__init__()
        self.project_list = []
        self.request = None
        self.project = None
        self.field = None

    listAcquired = pyqtSignal(list, arguments=['projectList'])
    infoAcquired = pyqtSignal(str, arguments=['projectInfo'])
    failed = pyqtSignal(str, arguments=['message'])

    def get_data(self, project=None, field=None, force=False):
        self.project = project
        self.field = field
        if force or not self.project_list:
            self.request = RequestThread()
            self.request.acquired.connect(self.on_acquired)
            self.request.start()
        else:
            self.on_acquired(self.project_list)

    def on_acquired(self, data):
        self.project_list = data

        if not self.project_list:
            self.failed.emit(u"连接失败")
            return

        if self.project and self.field:
            for prj in self.project_list:
                if prj['name'] == self.project:
                    self.infoAcquired.emit(prj[self.field])
                    return
            self.infoAcquired.emit('')
        else:
            result = []
            for prj in self.project_list:
                result.append(prj['name'])
            self.listAcquired.emit(result)

    @pyqtSlot()
    def get_list(self):
        self.get_data()

    @pyqtSlot(str, str)
    def get_info(self, project, field):
        self.get_data(project, field)


class RequestThread(QThread):

    acquired = pyqtSignal(list)

    def __init__(self):
        super(RequestThread, self).__init__()

    def run(self):
        self.acquired.emit(request('project'))
