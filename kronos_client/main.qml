import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.0
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0
import QtQuick.Window 2.2

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
        height: 50
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
        }

        Page {
            Asset {
                id: asset
            }
        }

        Page {
        }
    }

    footer: TabBar {
        id: tabBar
        currentIndex: 1
        TabButton {
            id: tabTask
            text: qsTr("任务")
            font.family: qsTr("微软雅黑")
            onClicked: {
                swipeView.currentIndex = 0
            }
        }
        TabButton {
            id: tabAsset
            text: qsTr("资产")
            font.family: qsTr("微软雅黑")
            onClicked: {
                swipeView.currentIndex = 1
            }
        }
        TabButton {
            id: tabShot
            text: qsTr("镜头")
            font.family: qsTr("微软雅黑")
            onClicked: {
                swipeView.currentIndex = 2
            }
        }
    }

    DropShadow {
        color: "#1a1a1a"
        samples: 20
        radius: 8
        anchors.fill: header
        source: header
    }
}
