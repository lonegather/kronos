# -*- coding: utf-8 -*-
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtCore import QCoreApplication, Qt
from PyQt5.QtQml import QQmlApplicationEngine


if __name__ == "__main__":
    import os
    import sys
    from models import preset, entity, utils

    os.putenv('QT_QUICK_CONTROLS_STYLE', 'Material')
    QCoreApplication.setAttribute(Qt.AA_EnableHighDpiScaling)

    app = QGuiApplication(sys.argv)
    prs = preset.Preset()
    ent = entity.EntityModel()
    scn = utils.ScreenShotProvider()

    engine = QQmlApplicationEngine()
    engine.rootContext().setContextProperty("preset", prs)
    engine.rootContext().setContextProperty("entityModel", ent)
    engine.addImageProvider("screen", scn)
    engine.load("qml/main.qml")
    engine.quit.connect(app.quit)

    sys.exit(app.exec_())
