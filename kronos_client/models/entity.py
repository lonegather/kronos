# -*- coding: utf-8 -*-
import json
from PyQt5.QtCore import QAbstractListModel, Qt, QModelIndex, pyqtSignal, pyqtSlot, QThread, QByteArray
from . import request


class EntityModel(QAbstractListModel):

    NameRole = Qt.UserRole + 1
    TagRole = Qt.UserRole + 2
    InfoRole = Qt.UserRole + 3
    PathRole = Qt.UserRole + 4

    def __init__(self, *args):
        super(EntityModel, self).__init__()
        self.__entity = []
        self.request = None

    @pyqtSlot(list)
    def update(self, filters):
        self.request = RequestThread(filters)
        self.request.acquired.connect(self.on_acquired)
        self.request.start()

    @pyqtSlot(int, str, result=str)
    def analyze(self, index, field):
        return json.dumps(self.__entity[index][field])

    def on_acquired(self, data):
        self.request = None
        self.__entity = data
        self.dataChanged.emit(QModelIndex(), QModelIndex())

    def rowCount(self, *args, **kwargs):
        return len(self.__entity)

    def data(self, index, role=Qt.DisplayRole):
        if role in [Qt.DisplayRole, self.NameRole]:
            return self.__entity[index.row()]['name']
        elif role == self.TagRole:
            return self.__entity[index.row()]['tag']
        elif role == self.InfoRole:
            return self.__entity[index.row()]['info']
        elif role == self.PathRole:
            return json.dumps(self.__entity[index.row()]['path'])

    def roleNames(self):
        role_names = super(EntityModel, self).roleNames()
        role_names[self.NameRole] = QByteArray(b'name')
        role_names[self.TagRole] = QByteArray(b'tag')
        role_names[self.InfoRole] = QByteArray(b'info')
        role_names[self.PathRole] = QByteArray(b'path')
        return role_names


class RequestThread(QThread):

    acquired = pyqtSignal(list)

    def __init__(self, filters):
        super(RequestThread, self).__init__()
        self.filters = {}
        for i in range(0, len(filters), 2):
            self.filters[filters[i]] = filters[i+1]

    def run(self):
        self.acquired.emit(request('entity', **self.filters))
