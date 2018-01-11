import QtQuick 2.0

HeaderForm {
    id: headerForm
    height: 50

    property string currentProject: projectCB.currentText
    signal projectChanged(string str)

    Component.onCompleted: {
        project.get_list()
    }

    projectCB.onActivated: {
        project.get_info(projectCB.currentText, "info")
        header.projectChanged(projectCB.currentText)
    }

    closeBtn.onClicked: {
        root.close()
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
            comboEnabled = true
        }
        onFailed: {
            projectLbl.text = message
            background = "#cc3333"
            comboEnabled = false
        }
    }
}
