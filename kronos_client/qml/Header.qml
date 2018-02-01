import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.0
import QtQuick.Window 2.3

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
                userInfo.visible = true
                userInfo.text = qsTr(auth.info())
                presetBtn.visible = auth.role() === "administrator" || auth.role() === "producer"
                loginBtn.visible = false
                logoutBtn.visible = true
            }
            onExited: {
                socket.active = false
                userInfo.text = ""
                userInfo.visible = false
                presetBtn.visible = false
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
        anchors.leftMargin: 5
        anchors.rightMargin: 5
        spacing: 0

        property int buttonWidth: 30

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
                padding: 10
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                font.family: qsTr("微软雅黑")
                font.weight: Font.Bold
                font.pixelSize: 17
                text: qsTr("正在连接...")
            }
        }

        ToolSeparator {
            width: 5
            Layout.fillHeight: true
        }

        Text {
            id: userInfo
            visible: false
            padding: 10
            color: "darkgray"
            font.family: qsTr("微软雅黑")
            font.weight: Font.Bold
            font.pixelSize: 17
            Layout.fillHeight: true
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
        }

        Rectangle {
            id: presetBtn
            visible: false
            color: "#00000000"
            Layout.fillHeight: true
            width: parent.buttonWidth
            Button {
                flat: true
                anchors.fill: parent
                onClicked: {
                    //
                }
                Image {
                    fillMode: Image.PreserveAspectFit
                    anchors.fill: parent
                    source: "preset.png"
                }
            }
        }

        Rectangle {
            id: loginBtn
            color: "#00000000"
            Layout.fillHeight: true
            width: parent.buttonWidth
            Button {
                flat: true
                anchors.fill: parent
                onClicked: {
                    inputDialog.open()
                }
                Image {
                    fillMode: Image.PreserveAspectFit
                    anchors.fill: parent
                    source: "login.png"
                }
            }
        }

        Rectangle {
            id: logoutBtn
            color: "#00000000"
            Layout.fillHeight: true
            width: parent.buttonWidth
            visible: false
            Button {
                flat: true
                anchors.fill: parent
                onClicked: {
                    auth.logout()
                }
                Image {
                    fillMode: Image.PreserveAspectFit
                    anchors.fill: parent
                    source: "logout.png"
                }
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
            width: parent.buttonWidth
            Button {
                flat: true
                anchors.fill: parent
                onClicked: {
                    root.visibility = Window.Minimized
                }
                Image {
                    fillMode: Image.PreserveAspectFit
                    anchors.fill: parent
                    source: "min.png"
                }
            }
        }

        Rectangle {
            id: closeBtn
            color: "#00000000"
            Layout.fillHeight: true
            width: parent.buttonWidth
            Button {
                flat: true
                anchors.fill: parent
                onClicked: {
                    root.close()
                }
                Image {
                    fillMode: Image.PreserveAspectFit
                    anchors.fill: parent
                    source: "exit.png"
                }
            }
        }
    }
}
