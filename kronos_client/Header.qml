import QtQuick 2.0

HeaderForm {
    id: headerForm
    height: 50

    property string currentProject: projectCB.currentText
    property bool available: comboEnabled
    signal projectChanged(string str)

    Component.onCompleted: {
        comboEnabled = false
        stage.get_data()
    }

    projectCB.onActivated: {
        comboEnabled = false
        project.get_info(projectCB.currentText, "info")
        header.projectChanged(projectCB.currentText)
    }

    closeBtn.onClicked: {
        root.close()
    }

    Connections {
        target: stage
        onAcquired: {
            project.get_list()
        }
        onFailed: {
            projectLbl.text = message
            background = "#cc3333"
        }
    }

    Connections {
        target: project
        onListAcquired: {
            projectCB.model = projectList
            project.get_info(projectCB.currentText, "info")
            header.projectChanged(projectCB.currentText)
        }
        onInfoAcquired: {
            projectLbl.text = projectInfo
            background = "#363636"
        }
        onFailed: {
            projectLbl.text = message
            background = "#cc3333"
        }
    }

    Connections {
        target: asset
        onAcquired: {
            comboEnabled = true
        }
    }
}
