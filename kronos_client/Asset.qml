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
                    pop.setPath(path)
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
            popName.text = str
        }

        function setInfo(str) {
            popInfo.text = str
        }

        function setTag(str) {
            popTag.text = str
        }

        function setPath(path) {
            pathModel.clear()
            var pathDic = JSON.parse(path)
            for (var i in pathDic) {
                pathModel.append({
                                     pathName: stage.data(i, 'info'),
                                     pathValue: pathDic[i]
                                 })
            }
        }

        ListModel {
            id: pathModel
        }

        Column {
            anchors.fill: parent
            Rectangle {
                color: "#00000000"
                width: pop.width
                height: 30
                Text {
                    id: popName
                    anchors.fill: parent
                    color: "darkgray"
                    font.pixelSize: 12
                    font.family: qsTr("微软雅黑")
                }
            }
            Rectangle {
                color: "#00000000"
                width: pop.width
                height: 30
                Text {
                    id: popInfo
                    anchors.fill: parent
                    color: "darkgray"
                    font.pixelSize: 12
                    font.family: qsTr("微软雅黑")
                }
            }
            Rectangle {
                color: "#00000000"
                width: pop.width
                height: 30
                Text {
                    id: popTag
                    anchors.fill: parent
                    color: "darkgray"
                    font.pixelSize: 12
                    font.family: qsTr("微软雅黑")
                }
            }
            Rectangle {
                color: "#00000000"
                width: pop.width
                height: pathView.count * 50
                ListView {
                    id: pathView
                    anchors.fill: parent
                    model: pathModel
                    delegate: Item {
                        width: pop.width
                        height: 50
                        Text {
                            anchors.fill: parent
                            text: pathName + ":" + pathValue
                            color: "darkgray"
                            font.pixelSize: 12
                            font.family: qsTr("微软雅黑")
                        }
                    }
                }
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
