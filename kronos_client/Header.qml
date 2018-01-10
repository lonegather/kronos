import QtQuick 2.7

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
        }
    }
}
