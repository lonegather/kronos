import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.0
import QtGraphicalEffects 1.0
import QtWebSockets 1.0

ApplicationWindow {
    id: root
    visible: true
    width: 1280
    height: 720
    flags: Qt.FramelessWindowHint | Qt.Window | Qt.WindowSystemMenuHint
           | Qt.WindowMinimizeButtonHint
    title: qsTr("资产库")
    Material.theme: Material.Dark
    Material.accent: Material.BlueGrey
    Material.foreground: Material.Grey

    header: Header {
        id: header
    }

    WebSocket {
        id: socket
        onTextMessageReceived: {
            console.log(message)
        }
        onStatusChanged: {
            console.log(socket.status)
        }
    }

    MouseArea {
        anchors.fill: header
        property point clickPos: "0,0"
        onPressed: {
            clickPos = Qt.point(mouse.x, mouse.y)
        }
        onPositionChanged: {
            var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
            root.setX(root.x + delta.x)
            root.setY(root.y + delta.y)
        }
    }

    SwipeView {
        id: swipeView
        interactive: false
        anchors.fill: parent
        currentIndex: 1

        Page {
            background: Rectangle {
                anchors.fill: parent
                color: "#33000000"
            }
        }

        Page {
            background: Rectangle {
                anchors.fill: parent
                color: "#33000000"
            }
            Asset {
                id: asset
            }
        }

        Page {
            background: Rectangle {
                anchors.fill: parent
                color: "#33000000"
            }
        }
    }

    footer: TabBar {
        id: tabBar
        currentIndex: 1
        TabButton {
            id: tabTask
            text: qsTr("任务")
            font.pointSize: 12
            font.weight: Font.Bold
            font.family: qsTr("微软雅黑")
            onClicked: {
                swipeView.currentIndex = 0
                asset.pop.close()
            }
        }
        TabButton {
            id: tabAsset
            text: qsTr("资产")
            font.pointSize: 12
            font.weight: Font.Bold
            font.family: qsTr("微软雅黑")
            onClicked: {
                socket.sendTextMessage("asset")
                swipeView.currentIndex = 1
            }
        }
        TabButton {
            id: tabShot
            text: qsTr("镜头")
            font.pointSize: 12
            font.weight: Font.Bold
            font.family: qsTr("微软雅黑")
            onClicked: {
                swipeView.currentIndex = 2
                asset.pop.close()
            }
        }
    }

    DropShadow {
        color: "#66000000"
        samples: 10
        radius: 10
        anchors.fill: header
        source: header
    }
}
