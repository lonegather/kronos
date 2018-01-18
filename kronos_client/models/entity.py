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
        self.__entity_filtered = []
        self.__filter = {}
        self.__link = []
        self.__link_current = ''
        self.request = None

    @pyqtSlot(list)
    def update(self, filters):
        self.request = RequestThread(filters)
        self.request.acquired.connect(self.on_acquired)
        self.request.start()

    @pyqtSlot(result=list)
    def filters(self):
        result = []
        for ent in self.__entity:
            if ent['tag'] not in result:
                result.append(ent['tag_info'])
        return result

    @pyqtSlot(result=list)
    def links(self):
        result = ['All']
        for link in self.__link:
            result.append(link['name'])
        return result

    @pyqtSlot(str, bool)
    def set_filter(self, f, v):
        self.__filter[f] = v
        self.update_filter()

    @pyqtSlot(str)
    def set_link(self, l):
        self.__link_current = l
        self.update_filter()

    def update_filter(self):
        self.__entity_filtered = []
        link_id = ''

        for link in self.__link:
            if link['name'] == self.__link_current:
                link_id = link['id']
                break

        for ent in self.__entity:
            if link_id and (link_id not in ent['link']):
                continue
            for flt in self.__filter:
                if ent['tag_info'] == flt and self.__filter[flt]:
                    self.__entity_filtered.append(ent)

        self.dataChanged.emit(QModelIndex(), QModelIndex())

    def on_acquired(self, data):
        link = []
        self.__entity = data
        self.__entity_filtered = data
        for ent in self.__entity:
            self.__filter[ent['tag_info']] = True
            for l in ent['link']:
                if l not in link:
                    link.append(l)

        self.request = RequestLinkThread(link)
        self.request.acquired.connect(self.on_link_acquired)
        self.request.start()

    def on_link_acquired(self, data):
        self.request = None
        self.__link = data
        self.dataChanged.emit(QModelIndex(), QModelIndex())

    def rowCount(self, *args, **kwargs):
        return len(self.__entity_filtered)

    def data(self, index, role=Qt.DisplayRole):
        if role in [Qt.DisplayRole, self.NameRole]:
            return self.__entity_filtered[index.row()]['name']
        elif role == self.TagRole:
            return self.__entity_filtered[index.row()]['tag']
        elif role == self.InfoRole:
            return self.__entity_filtered[index.row()]['info']
        elif role == self.PathRole:
            return json.dumps(self.__entity_filtered[index.row()]['path'])

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


class RequestLinkThread(QThread):

    acquired = pyqtSignal(list)

    def __init__(self, id_list):
        super(RequestLinkThread, self).__init__()
        self.filter = {'list': json.dumps(id_list)}

    def run(self):
        self.acquired.emit(request('entity_id', **self.filter))
