import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.0

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

    loginBtn.onClicked: {
        inputDialog.open()
    }

    closeBtn.onClicked: {
        root.close()
    }

    Dialog {
        id: inputDialog

        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        parent: ApplicationWindow.overlay

        focus: true
        modal: true
        title: qsTr("登录")
        standardButtons: Dialog.Ok | Dialog.Cancel

        ColumnLayout {
            spacing: 20
            anchors.fill: parent
            Label {
                elide: Label.ElideRight
                text: qsTr("请输入用户名密码：")
                Layout.fillWidth: true
            }
            TextField {
                focus: true
                placeholderText: "Username"
                Layout.fillWidth: true
            }
            TextField {
                placeholderText: "Password"
                echoMode: TextField.PasswordEchoOnEdit
                Layout.fillWidth: true
            }
        }
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
