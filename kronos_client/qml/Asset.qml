import QtQuick 2.7
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3

Item {
    anchors.margins: 5
    anchors.fill: parent

    property alias pop: pop
    signal acquired

    Column {
        id: grid
        anchors.fill: parent
        anchors.margins: 10
        spacing: 5

        Rectangle {
            id: filterBar
            radius: 5
            height: 50
            visible: false
            width: parent.width
            color: "#272727"

            signal filterChanged

            ListView {
                id: filterView
                spacing: 10
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                orientation: ListView.Horizontal
                delegate: Item {
                    id: filterItem
                    height: parent.height
                    width: 80
                    CheckBox {
                        checked: true
                        anchors.fill: parent
                        text: modelData
                        font.weight: Font.Bold
                        font.pointSize: 12
                        font.family: qsTr("微软雅黑")
                        onToggled: {
                            gridView.model = []
                            entityModel.set_filter(text, checked)
                        }
                    }
                }
            }

            Connections {
                target: entityModel
                onDataChanged: {
                    filterView.model = entityModel.filters()
                }
            }
        }

        GridView {
            id: gridView
            clip: true
            focus: true
            height: parent.height - 50
            width: parent.width
            cellWidth: 158
            cellHeight: 183
            flickableDirection: Flickable.AutoFlickIfNeeded
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
                    },
                    State {
                        name: "hover"
                        PropertyChanges {
                            target: shader
                            color: "#994a4a4a"
                        }
                        PropertyChanges {
                            target: shadow
                            color: "#99b0bec5"
                            verticalOffset: 0
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

                DropShadow {
                    id: shadow
                    color: "#33000000"
                    samples: 20
                    radius: 10
                    verticalOffset: 3
                    anchors.fill: shader
                    source: shader
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
    }

    Popup {
        id: pop
        width: grid.width
        height: grid.height
        x: grid.x
        y: grid.y
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
                flickableDirection: Flickable.AutoFlickIfNeeded
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
            filterBar.visible = false
            gridView.model = []
            filterView.model = []
            pop.close()
            entityModel.update(
                        ["project", header.currentProject, "genus", "asset"])
        }
    }

    Connections {
        target: entityModel
        onDataChanged: {
            filterBar.visible = true
            gridView.model = entityModel
            acquired()
        }
    }
}
