import QtQuick 2.7
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0

Item {
    GridView {
        id: gridView
        anchors.fill: parent
        cellWidth: 145
        cellHeight: 170
        delegate: Item {
            id: wrapper
            width: gridView.cellWidth
            height: gridView.cellHeight

            property string name: name
            property string info: info
            property string tag: tag
            property string path: path

            Rectangle {
                id: shader
                radius: 5
                color: wrapper.GridView.isCurrentItem ? "#00000000" : "#333333"
                anchors.fill: parent
                anchors.margins: 3
            }

            Column {
                anchors.margins: 8
                anchors.fill: parent
                spacing: 5
                Rectangle {
                    width: 128
                    height: 128
                    color: "darkgray"
                }
                Text {
                    text: info
                    color: wrapper.GridView.isCurrentItem ? "#b0bec5" : "darkgray"
                    font.family: qsTr("微软雅黑")
                    font.pixelSize: 14
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    gridView.currentIndex = index
                }
                onDoubleClicked: {
                    stack.push(detail)
                }
            }
        }
        focus: true
        highlight: Rectangle {
            radius: 3
            color: "#22b0bec5"
        }
    }

    Connections {
        target: header
        onProjectChanged: {
            gridView.model = []
            entityModel.update(["project", header.currentProject, "genus", "asset"])
        }
    }

    Connections {
        target: entityModel
        onDataChanged: {
            gridView.model = entityModel
            gridView.currentIndex = -1
        }
    }

    DropShadow {
        color: "#1a1a1a"
        samples: 20
        radius: 8
        anchors.fill: gridView
        source: gridView
    }
}
