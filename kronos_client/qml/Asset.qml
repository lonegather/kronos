import QtQuick 2.7
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0

Item {
    anchors.margins: 5
    anchors.fill: parent

    property alias pop: pop
    signal acquired

    GridView {
        id: gridView
        clip: true
        focus: true
        anchors.fill: parent
        cellWidth: 158
        cellHeight: 183
        delegate: Item {
            id: wrapper
            width: gridView.cellWidth
            height: gridView.cellHeight
            focus: true
            states: [
                State {
                    name: "selected"
                    PropertyChanges {
                        target: shader
                        color: "#00b0bec5"
                    }
                    PropertyChanges {
                        target: label
                        font.pixelSize: 15
                    }
                    PropertyChanges {
                        target: column
                        spacing: 6
                    }
                },
                State {
                    name: "hover"
                    PropertyChanges {
                        target: shader
                        color: "#4a4a4a"
                        scale: 1.02
                    }
                    PropertyChanges {
                        target: label
                        font.pixelSize: 15
                    }
                    PropertyChanges {
                        target: column
                        spacing: 6
                    }
                }

            ]
            transitions: [
                Transition {
                    ColorAnimation {
                        target: shader
                        property: "color"
                        duration: 200
                        easing.type: Easing.InOutQuad
                    }
                },
                Transition {
                    SmoothedAnimation {
                        target: shader
                        property: "scale"
                        duration: 1000
                        easing.type: Easing.InOutBack
                    }
                }
            ]
            GridView.onCurrentItemChanged: {
                wrapper.state = wrapper.GridView.isCurrentItem ? "selected" : ""
            }

            Rectangle {
                id: shader
                radius: 5
                scale: 1.0
                color: "#3e3e3e"
                anchors.fill: parent
                anchors.margins: 8
            }

            Column {
                id: column
                anchors.margins: 15
                anchors.fill: parent
                spacing: 5
                Rectangle {
                    width: 128
                    height: 128
                    scale: shader.scale
                    color: "darkgray"
                }
                Text {
                    id: label
                    text: name
                    elide: Text.ElideRight
                    color: wrapper.GridView.isCurrentItem ? "#b0bec5" : "darkgray"
                    font.family: qsTr("微软雅黑")
                    font.pixelSize: 14
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    gridView.currentIndex = index
                }
                onEntered: {
                    if (!wrapper.GridView.isCurrentItem) {
                        wrapper.state = "hover"
                    }
                }
                onExited: {
                    if (!wrapper.GridView.isCurrentItem) {
                        wrapper.state = ""
                    }
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
        closePolicy: Popup.CloseOnEscape

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

        Row {
            id: popBrief
            anchors.margins: 21
            anchors.fill: parent
            spacing: anchors.margins
            Column {
                spacing: 10
                width: (popBrief.width - popBrief.anchors.margins) / 3
                Rectangle {
                    color: "grey"
                    width: parent.width
                    height: width
                }
                Rectangle {
                    color: "#00000000"
                    width: parent.width
                    height: 30
                    Text {
                        id: popName
                        anchors.fill: parent
                        color: "darkgray"
                        font.pixelSize: 30
                        font.family: qsTr("微软雅黑")
                    }
                }
                Rectangle {
                    color: "#00000000"
                    width: parent.width
                    height: 20
                    Text {
                        id: popTag
                        anchors.fill: parent
                        color: "darkgray"
                        font.pixelSize: 20
                        font.family: qsTr("微软雅黑")
                    }
                }
                Rectangle {
                    color: "#00000000"
                    width: parent.width
                    height: 100
                    Text {
                        id: popInfo
                        anchors.fill: parent
                        color: "darkgray"
                        font.pixelSize: 20
                        font.family: qsTr("微软雅黑")
                        wrapMode: Text.WordWrap
                    }
                }
            }

            ListView {
                id: pathView
                width: (popBrief.width - popBrief.anchors.margins) / 3 * 2
                height: popBrief.height
                clip: true
                spacing: 12
                model: pathModel
                delegate: Item {
                    width: parent.width
                    height: 100
                    clip: true
                    Rectangle {
                        anchors.fill: parent
                        radius: 5
                        color: "#33000000"
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
            pop.close()
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
        color: "#55000000"
        samples: 10
        radius: 10
        verticalOffset: 5
        anchors.fill: gridView
        source: gridView
    }
}
