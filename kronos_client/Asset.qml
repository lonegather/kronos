import QtQuick 2.0
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0

Item {
    anchors.rightMargin: 5
    anchors.leftMargin: 5
    anchors.bottomMargin: 5
    anchors.topMargin: 5
    anchors.fill: parent

    signal acquired

    GridView {
        id: gridView
        anchors.fill: parent
        cellWidth: 145
        cellHeight: 170
        delegate: Item {
            id: wrapper
            width: gridView.cellWidth
            height: gridView.cellHeight

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
                    text: name
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
                    pop.setName(name)
                    pop.setInfo(info)
                    pop.setTag(tag)
                    var pathDic = JSON.parse(path)
                    for (var i in pathDic) {
                        console.log(stage.data(i, 'info') + ": " + pathDic[i])
                    }
                    pop.open()
                }
            }
        }
        focus: true
        highlight: Rectangle {
            radius: 3
            color: "#22b0bec5"
        }
    }

    Popup {
        id: pop
        width: parent.width
        height: parent.height
        x: parent.x - 5
        y: parent.y - 5
        modal: false
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        function setName(str) {
            name.text = str
        }

        function setInfo(str) {
            info.text = str
        }

        function setTag(str) {
            tag.text = str
        }

        Column {
            Text {
                id: name
                color: "darkgray"
                font.pixelSize: 12
                font.family: qsTr("微软雅黑")
            }
            Text {
                id: info
                color: "darkgray"
                font.pixelSize: 12
                font.family: qsTr("微软雅黑")
            }
            Text {
                id: tag
                color: "darkgray"
                font.pixelSize: 12
                font.family: qsTr("微软雅黑")
            }
        }
    }

    Connections {
        target: header
        onProjectChanged: {
            gridView.model = []
            entityModel.update(
                        ["project", header.currentProject, "genus", "asset"])
        }
    }

    Connections {
        target: entityModel
        onDataChanged: {
            gridView.model = entityModel
            gridView.currentIndex = -1
            acquired()
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
