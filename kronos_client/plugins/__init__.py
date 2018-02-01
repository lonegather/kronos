# -*- coding: utf-8 -*-
import os
from PyQt5.QtCore import QObject, pyqtSignal


class Process(QObject):

    progressed = pyqtSignal(float)

    def __init__(self, name, path):
        super(Process, self).__init__()
        self.__name = name
        self.__path = path

    def inputs(self):
        """
        :return: {'name': type, ...}
        """
        pass
