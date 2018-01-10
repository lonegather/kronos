# -*- coding: utf-8 -*-
from PyQt5.QtCore import QObject, pyqtSignal, pyqtSlot
from . import request


class Project(QObject):

    def __init__(self):
        super(Project, self).__init__()
        self.project_list = []

    listAcquired = pyqtSignal(list, arguments=['projectList'])
    infoAcquired = pyqtSignal(str, arguments=['projectInfo'])
    failed = pyqtSignal(str, arguments=['message'])

    def get_data(self, force=False):
        if force or not self.project_list:
            self.project_list = request('project')

    @pyqtSlot()
    def get_list(self):
        self.get_data()

        if not self.project_list:
            self.failed.emit(u"与服务器连接失败")
            return

        result = []
        for prj in self.project_list:
            result.append(prj['name'])
        self.listAcquired.emit(result)

    @pyqtSlot(str, str)
    def get_info(self, project, field):
        self.get_data()
        for prj in self.project_list:
            if prj['name'] == project:
                self.infoAcquired.emit(prj[field])
                return

        self.infoAcquired.emit('')
