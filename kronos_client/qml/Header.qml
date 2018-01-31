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

        onAccepted: {
            auth.login(textUsername.text, textPassword.text)
        }

        ColumnLayout {
            spacing: 20
            anchors.fill: parent
            Label {
                elide: Label.ElideRight
                text: qsTr("请输入用户名密码：")
                Layout.fillWidth: true
            }
            TextField {
                id: textUsername
                focus: true
                placeholderText: qsTr("用户名")
                Layout.fillWidth: true
            }
            TextField {
                id: textPassword
                placeholderText: qsTr("密码")
                echoMode: TextField.Password
                Layout.fillWidth: true
                onAccepted: {
                    if(textUsername.text){
                        inputDialog.accept()
                    }
                }
            }
        }

        Connections {
            target: auth
            onGranted: {
                var url = "ws://" + preset.host() + "/?session_key=" + auth.session()
                socket.url = url
                socket.active = true
                userInfo.text = qsTr("欢迎，" + auth.info())
                loginBtn.visible = false
                logoutBtn.visible = true
            }
            onExited: {
                socket.active = false
                userInfo.text = ""
                loginBtn.visible = true
                logoutBtn.visible = false
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
        anchors.margins: 5
        spacing: 0

        ComboBox {
            id: projectCB
            flat: true
            enabled: false
            font.family: qsTr("微软雅黑")
            anchors.left: parent.left
            Layout.fillHeight: true
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

        Text {
            id: userInfo
            rightPadding: 10
            color: "darkgray"
            font.family: qsTr("微软雅黑")
            font.weight: Font.Bold
            font.pixelSize: 17
            Layout.fillHeight: true
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
        }

        ToolButton {
            id: loginBtn
            text: qsTr("登录")
            font.weight: Font.Bold
            font.pointSize: 12
            font.family: qsTr("微软雅黑")
            Layout.fillHeight: true
            onClicked: {
                inputDialog.open()
            }
        }

        ToolButton {
            id: logoutBtn
            visible: false
            text: qsTr("注销")
            font.weight: Font.Bold
            font.pointSize: 12
            font.family: qsTr("微软雅黑")
            Layout.fillHeight: true
            onClicked: {
                auth.logout()
            }
        }

        ToolSeparator {
            width: 5
            Layout.fillHeight: true
        }

        Rectangle {
            id: minBtn
            color: "#00000000"
            Layout.fillHeight: true
            width: parent.height
            states: State {
                name: "hover"
                PropertyChanges {
                    target: minBtn
                    color: "#33ffffff"
                }
            }
            transitions: Transition {
                ColorAnimation {
                    target: minBtn
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
                    //
                }
                onEntered: {
                    parent.state = "hover"
                }
                onExited: {
                    parent.state = ""
                }
            }
        }

        Rectangle {
            id: closeBtn
            color: "#00000000"
            Layout.fillHeight: true
            width: parent.height
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
