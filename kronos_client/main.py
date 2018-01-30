# -*- coding: utf-8 -*-
import os
import sys
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtCore import QCoreApplication, Qt, QUrl
from PyQt5.QtQml import QQmlApplicationEngine


if __name__ == "__main__":
    from models import preset, entity, utils

    os.putenv('QT_QUICK_CONTROLS_STYLE', 'Material')
    QCoreApplication.setAttribute(Qt.AA_EnableHighDpiScaling)

    path = os.path.dirname(__file__)
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    prs = preset.Preset(engine)
    ent = entity.EntityModel(engine)
    scn = utils.ScreenShot(engine)
    usr = utils.Auth(engine)

    engine.load(QUrl.fromLocalFile("%s/qml/main.qml" % path))
    engine.quit.connect(app.quit)

    sys.exit(app.exec_())
