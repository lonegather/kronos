# -*- coding: utf-8 -*-
from PyQt5.QtCore import QAbstractListModel, Qt, QModelIndex, pyqtSlot
from . import request


class EntityModel(QAbstractListModel):

    def __init__(self, *args):
        super(EntityModel, self).__init__()
        self.__entity = []

    @pyqtSlot(list)
    def update(self, filters):
        kwargs = {}
        for i in range(0, len(filters), 2):
            kwargs[filters[i]] = filters[i+1]
        self.__entity = request('entity', **kwargs)
        self.dataChanged.emit(QModelIndex(), QModelIndex())

    def rowCount(self, *args, **kwargs):
        return len(self.__entity)

    def data(self, index, role=Qt.DisplayRole):
        if role == Qt.DisplayRole:
            return self.__entity[index.row()]['name']

    def roleNames(self):
        return super(EntityModel, self).roleNames()
