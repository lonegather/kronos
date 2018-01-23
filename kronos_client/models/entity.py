# -*- coding: utf-8 -*-
import json
from PyQt5.QtCore import QAbstractListModel, Qt, QModelIndex, pyqtSignal, pyqtSlot, QThread, QByteArray
from . import request, commit


class EntityModel(QAbstractListModel):

    IDRole = Qt.UserRole + 1
    NameRole = Qt.UserRole + 2
    TagRole = Qt.UserRole + 3
    InfoRole = Qt.UserRole + 4
    LinkRole = Qt.UserRole + 5
    PathRole = Qt.UserRole + 6
    ThumbRole = Qt.UserRole + 7

    def __init__(self, *args):
        super(EntityModel, self).__init__()
        self.__entity = []
        self.__entity_filtered = []
        self.__filter = {}
        self.__link = []
        self.__link_current = ''
        self.__project = ''
        self.__genus = ''
        self.thread = None

    @pyqtSlot(list)
    def update(self, filters):
        self.__project = filters[1]
        self.__genus = filters[3]
        self.thread = RequestThread(filters)
        self.thread.acquired.connect(self.on_acquired)
        self.thread.start()

    @pyqtSlot(result=list)
    def filters(self):
        result = []
        for ent in self.__entity:
            if ent['tag_info'] not in result:
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

    @pyqtSlot(str, str)
    def set_link(self, l, batch):
        self.__link_current = l
        self.__link = json.loads(batch)
        self.update_filter()

    @pyqtSlot(str)
    def set_asset(self, form):
        self.thread = CommitThread(form)
        self.thread.finished.connect(self.on_finished)
        self.thread.start()

    def on_finished(self):
        self.update(['project', self.__project, 'genus', self.__genus])

    def on_failed(self):
        self.dataChanged.emit(QModelIndex(), QModelIndex())

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
        self.__entity = data
        self.__entity_filtered = data
        for ent in self.__entity:
            self.__filter[ent['tag_info']] = True
        self.dataChanged.emit(QModelIndex(), QModelIndex())

    def rowCount(self, *args, **kwargs):
        return len(self.__entity_filtered)

    def data(self, index, role=Qt.DisplayRole):
        if role in [Qt.DisplayRole, self.NameRole]:
            return self.__entity_filtered[index.row()]['name']
        elif role == self.IDRole:
            return self.__entity_filtered[index.row()]['id']
        elif role == self.TagRole:
            return self.__entity_filtered[index.row()]['tag']
        elif role == self.InfoRole:
            return self.__entity_filtered[index.row()]['info']
        elif role == self.LinkRole:
            return json.dumps(self.__entity_filtered[index.row()]['link'])
        elif role == self.PathRole:
            return json.dumps(self.__entity_filtered[index.row()]['path'])
        elif role == self.ThumbRole:
            return self.__entity_filtered[index.row()]['thumb']

    def roleNames(self):
        role_names = super(EntityModel, self).roleNames()
        role_names[self.IDRole] = QByteArray(b'entID')
        role_names[self.NameRole] = QByteArray(b'name')
        role_names[self.TagRole] = QByteArray(b'tag')
        role_names[self.InfoRole] = QByteArray(b'info')
        role_names[self.LinkRole] = QByteArray(b'link')
        role_names[self.PathRole] = QByteArray(b'path')
        role_names[self.ThumbRole] = QByteArray(b'thumb')
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


class CommitThread(QThread):

    finished = pyqtSignal()
    failed = pyqtSignal()

    def __init__(self, form):
        super(CommitThread, self).__init__()
        self.form = json.loads(form)

    def run(self):
        if commit('entity', **self.form):
            self.finished.emit()
        else:
            self.failed.emit()
