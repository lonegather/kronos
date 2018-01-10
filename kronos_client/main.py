# -*- coding: utf-8 -*-
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtCore import QCoreApplication, Qt
from PyQt5.QtQml import QQmlApplicationEngine, qmlRegisterType


if __name__ == "__main__":
    import os
    import sys
    from models import project, entity

    os.putenv('QT_QUICK_CONTROLS_STYLE', 'Material')
    QCoreApplication.setAttribute(Qt.AA_EnableHighDpiScaling)

    app = QGuiApplication(sys.argv)
    prj = project.Project()
    qmlRegisterType(entity.EntityModel, "kronos.entity", 1, 0, "EntityModel")

    engine = QQmlApplicationEngine()
    engine.rootContext().setContextProperty("project", prj)
    engine.load("main.qml")
    engine.quit.connect(app.quit)

    sys.exit(app.exec_())
