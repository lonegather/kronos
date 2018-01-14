# -*- coding: utf-8 -*-
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtCore import QCoreApplication, Qt
from PyQt5.QtQml import QQmlApplicationEngine


if __name__ == "__main__":
    import os
    import sys
    from models import project, stage, entity

    os.putenv('QT_QUICK_CONTROLS_STYLE', 'Material')
    QCoreApplication.setAttribute(Qt.AA_EnableHighDpiScaling)

    app = QGuiApplication(sys.argv)
    prj = project.Project()
    stg = stage.Stage()
    ent = entity.EntityModel()

    engine = QQmlApplicationEngine()
    engine.rootContext().setContextProperty("project", prj)
    engine.rootContext().setContextProperty("stage", stg)
    engine.rootContext().setContextProperty("entityModel", ent)
    engine.load("qml/main.qml")
    engine.quit.connect(app.quit)

    sys.exit(app.exec_())
