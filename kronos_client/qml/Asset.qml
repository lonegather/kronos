import QtQuick 2.7
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3

Item {
    anchors.margins: 5
    anchors.fill: parent

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
            color: "#2a2a2a"

            signal filterChanged

            Row {
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                anchors.fill: parent
                spacing: 10

                ComboBox {
                    id: filterLink
                    font.family: qsTr("微软雅黑")
                    height: parent.height - parent.spacing
                    anchors.verticalCenter: parent.verticalCenter
                    onActivated: {
                        gridView.model = []
                        entityModel.set_link(currentText)
                    }
                }

                ListView {
                    id: filterView
                    spacing: 10
                    x: filterLink.width + parent.spacing
                    width: parent.width - parent.spacing - filterLink.width - addBtn.width
                    height: parent.height
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

                ToolButton {
                    id: addBtn
                    flat: true
                    width: parent.height
                    Layout.fillHeight: true
                }

                Connections {
                    target: entityModel
                    onDataChanged: {
                        filterView.model = entityModel.filters()
                        filterLink.model = entityModel.links()
                    }
                }
            }
        }

        GridView {
            id: gridView
            clip: true
            focus: true
            height: parent.height - parent.spacing - filterBar.height
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
                        text: info == "" ? name : info
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
                        var space = grid.anchors.margins
                        var gx = mouse.x + wrapper.x + gridView.x + space - pop.width / 2
                        var gy = mouse.y + wrapper.y + gridView.y + space - pop.height / 2
                        pop.x = Math.min(gridView.width - space,
                                         Math.max(space, gx))
                        pop.y = Math.min(gridView.height - space,
                                         Math.max(filterBar.height + space, gy))
                        pop.setName(name)
                        pop.setInfo(info)
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

    BusyIndicator {
        id: busy
        anchors.centerIn: parent
    }

    Popup {
        id: pop
        width: 506
        height: 319
        modal: false
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        function setName(str) {
            popName.text = str
        }

        function setInfo(str) {
            popInfo.text = str
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
            id: popBrief
            anchors.margins: 5
            anchors.fill: parent
            spacing: anchors.margins + 5
            Row {
                id: bio
                spacing: 10
                width: parent.width
                height: 128
                Rectangle {
                    color: "grey"
                    width: height
                    height: parent.height
                }
                Column {
                    width: bio.width - option.width - bio.spacing * 2 - 128
                    height: parent.height
                    Rectangle {
                        color: "#33000000"
                        width: parent.width
                        height: 43
                        Label {
                            id: popName
                            anchors.fill: parent
                            color: "darkgray"
                            font.pixelSize: 20
                            font.family: qsTr("微软雅黑")
                        }
                        TextField {
                            id: popNameInput
                            anchors.fill: parent
                            color: popName.color
                            font.pixelSize: popName.font.pixelSize
                            font.family: popName.font.family
                        }
                    }
                    Rectangle {
                        color: "#22000000"
                        width: parent.width
                        height: 85
                        TextArea {
                            id: popInfo
                            anchors.fill: parent
                            color: "darkgray"
                            font.pixelSize: 15
                            font.family: qsTr("微软雅黑")
                            wrapMode: Text.WordWrap
                        }
                        TextArea {
                            id: popInfoInput
                            anchors.fill: parent
                            color: popInfo.color
                            font.pixelSize: popInfo.font.pixelSize
                            font.family: popInfo.font.family
                            wrapMode: Text.WordWrap
                        }
                    }
                }
                Column {
                    id: option
                    width: 40
                    height: parent.height
                    Rectangle {
                        color: "#33000000"
                        width: parent.width
                        height: width
                        ToolButton {
                            anchors.fill: parent
                        }
                    }
                    Rectangle {
                        color: "#22000000"
                        width: parent.width
                        height: width
                        ToolButton {
                            anchors.fill: parent
                        }
                    }
                    Rectangle {
                        color: "#33000000"
                        width: parent.width
                        height: width
                        ToolButton {
                            anchors.fill: parent
                        }
                    }
                }
            }

            ListView {
                id: pathView
                width: bio.width
                height: popBrief.height - bio.height - bio.spacing
                clip: true
                spacing: 5
                model: pathModel
                flickableDirection: Flickable.AutoFlickIfNeeded
                delegate: Item {
                    width: parent.width
                    height: 50
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
            busy.visible = true
            filterBar.visible = false
            gridView.model = []
            pop.close()
            entityModel.update(
                        ["project", header.currentProject, "genus", "asset"])
        }
    }

    Connections {
        target: entityModel
        onDataChanged: {
            busy.visible = false
            filterBar.visible = true
            gridView.model = entityModel
            acquired()
        }
    }
}
