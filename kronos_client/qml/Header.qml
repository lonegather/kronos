import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.0

Rectangle {
    id: headerForm
    height: 50
    color: "#363636"

    property string currentProjectID: ""
    property string currentProject: projectCB.currentText
    signal projectChanged(string str)

    function refresh() {
        projectChanged(projectCB.currentText)
    }

    Component.onCompleted: {
        projectCB.enabled = false
        preset.get_data()
    }

    Dialog {
        id: inputDialog
        x: parent.width - width
        y: headerForm.height
        parent: ApplicationWindow.overlay
        focus: true
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
        target: preset
        onAcquired: {
            var presetProject = JSON.parse(preset.data("project"))
            var projectModel = []
            for (var i in presetProject) {
                projectModel[i] = presetProject[i]["name"]
            }
            projectCB.model = projectModel
            projectLbl.text = presetProject[projectCB.currentIndex]["info"]
            currentProjectID = presetProject[projectCB.currentIndex]["id"]
            header.projectChanged(projectCB.currentText)
            headerForm.color = "#363636"
        }
        onFailed: {
            projectLbl.text = message
            headerForm.color = "#cc3333"
        }
    }

    Connections {
        target: asset
        onAcquired: {
            projectCB.enabled = true
        }
    }

    RowLayout {
        id: rowLayout
        anchors.fill: parent
        spacing: 0

        ComboBox {
            id: projectCB
            flat: true
            enabled: false
            font.family: qsTr("微软雅黑")
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            Layout.fillHeight: true
            anchors.leftMargin: 5
            onActivated: {
                projectCB.enabled = false
                var presetProject = JSON.parse(preset.data("project"))
                projectLbl.text = presetProject[projectCB.currentIndex]["info"]
                currentProjectID = presetProject[projectCB.currentIndex]["id"]
                header.projectChanged(projectCB.currentText)
            }
        }

        Rectangle {
            color: "#00000000"
            Layout.fillHeight: true
            Layout.fillWidth: true
            Text {
                id: projectLbl
                color: "darkgray"
                anchors.fill: parent
                anchors.leftMargin: 20
                anchors.rightMargin: 20
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                font.family: qsTr("微软雅黑")
                font.weight: Font.Bold
                font.pixelSize: 17
                text: qsTr("正在连接...")
            }
        }

        ToolButton {
            id: loginBtn
            text: qsTr("登录")
            font.weight: Font.Bold
            font.pointSize: 12
            font.family: qsTr("微软雅黑")
            onClicked: {
                inputDialog.open()
            }
        }

        Rectangle {
            id: closeBtn
            color: "#00000000"
            Layout.fillHeight: true
            Layout.minimumWidth: 50
            states: State {
                name: "hover"
                PropertyChanges {
                    target: closeBtn
                    color: "#33ff3333"
                }
            }
            transitions: Transition {
                ColorAnimation {
                    target: closeBtn
                    duration: 200
                }
            }

            Image {
                anchors.fill: parent
                source: "exit.png"
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    root.close()
                }
                onEntered: {
                    parent.state = "hover"
                }
                onExited: {
                    parent.state = ""
                }
            }
        }
    }
}
