import QtQuick 2.7
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3

Item {
    anchors.margins: 5
    anchors.fill: parent
    property alias pop: assetInfo.pop
    signal acquired

    Column {
        id: grid
        anchors.fill: parent
        anchors.margins: 0

        Rectangle {
            id: filterBar
            height: 40
            visible: false
            width: parent.width
            color: "#33000000"

            signal filterChanged

            Row {
                anchors.fill: parent

                ToolSeparator {
                    height: parent.height
                }

                ToolButton {
                    id: addBtn
                    width: parent.height
                    height: parent.height

                    onClicked: {
                        assetInfo.state = "new"
                        assetInfo.x = (gridView.width - assetInfo.popWidth) / 2
                        assetInfo.y = (gridView.height - assetInfo.popHeight) / 2
                        assetInfo.pop.open()
                    }

                    Image {
                        anchors.fill: parent
                        source: "add.png"
                    }
                }

                ToolButton {
                    id: delBtn
                    width: parent.height
                    height: parent.height
                    onClicked: {

                    }
                    Image {
                        anchors.fill: parent
                        source: "del.png"
                    }
                }

                ToolButton {
                    id: impBtn
                    width: parent.height
                    height: parent.height
                }

                ToolButton {
                    id: synBtn
                    width: parent.height
                    height: parent.height
                }

                ToolSeparator {
                    id: sep
                    height: parent.height
                }

                ListView {
                    id: filterView
                    spacing: 10
                    width: parent.width - filterRec.width - addBtn.width - delBtn.width
                           - impBtn.width - synBtn.width - sep.width * 3
                    height: parent.height
                    orientation: ListView.Horizontal
                    layoutDirection: Qt.RightToLeft
                    delegate: Item {
                        id: filterItem
                        height: parent.height
                        width: 100
                        CheckBox {
                            checked: true
                            anchors.fill: parent
                            text: modelData
                            font.pointSize: 12
                            font.family: qsTr("微软雅黑")
                            onToggled: {
                                gridView.model = []
                                entityModel.set_filter(text, checked)
                            }
                        }
                    }
                    Rectangle {
                        anchors.fill: parent
                        color: "#00000000"
                    }
                }

                Rectangle {
                    id: filterRec
                    width: 100
                    height: parent.height
                    color: "#00000000"
                    ComboBox {
                        id: filterLink
                        font.family: qsTr("微软雅黑")
                        anchors.fill: parent
                        onActivated: {
                            gridView.model = []
                            var presetBatch = JSON.parse(preset.data("batch"))
                            var batch = []
                            for (var i in presetBatch) {
                                if (presetBatch[i]["project"] === header.currentProject) {
                                    batch.push(presetBatch[i])
                                }
                            }

                            entityModel.set_link(currentText,
                                                 JSON.stringify(batch))
                        }
                    }
                }

                ToolSeparator {
                    height: parent.height
                }

                Connections {
                    target: entityModel
                    onDataChanged: {
                        var presetBatch = JSON.parse(preset.data("batch"))
                        var batchList = ["All"]
                        for (var i in presetBatch) {
                            if (presetBatch[i]["project"] === header.currentProject) {
                                batchList.push(presetBatch[i]["name"])
                            }
                        }

                        filterView.model = entityModel.filters()
                        filterLink.model = batchList
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
            cellWidth: 158.5
            cellHeight: 183
            flickableDirection: Flickable.AutoFlickIfNeeded

            property int concurrent: 0

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
                            color: "#555a5c"
                        }
                    },
                    State {
                        name: "hover"
                        PropertyChanges {
                            target: shader
                            color: "#4a4a4a"
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
                    anchors.margins: 5
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
                    anchors.margins: 15.5
                    anchors.fill: parent
                    spacing: 5
                    Rectangle {
                        width: 128
                        height: 128
                        scale: shader.scale
                        color: "#00000000"
                        BusyIndicator {
                            id: bi
                            anchors.centerIn: parent
                        }

                        Timer {
                            id: timer
                            interval: 1000
                            triggeredOnStart: true
                            onTriggered: {
                                if (gridView.concurrent > 0) {
                                    if (img.status !== Image.Loading) {
                                        gridView.concurrent -= 1
                                    }
                                    img.source = ""
                                    img.source = preset.host() + thumb
                                }
                                timer.restart()
                            }
                        }

                        Image {
                            id: img
                            anchors.fill: parent
                            sourceSize.width: 128
                            sourceSize.height: 128
                            onStatusChanged: {
                                if (img.status === Image.Ready) {
                                    gridView.concurrent += 1
                                    bi.visible = false
                                    timer.stop()
                                }
                            }

                            Component.onCompleted: {
                                timer.start()
                            }
                        }
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
                        assetInfo.pop.close()
                        var space = grid.anchors.margins
                        var gx = mouse.x + wrapper.x + gridView.x
                                - gridView.contentX + space - assetInfo.popWidth / 2
                        var gy = mouse.y + wrapper.y + gridView.y - gridView.contentY
                                + space - assetInfo.popHeight / 2
                        assetInfo.state = ""
                        assetInfo.x = Math.min(
                                    gridView.x + gridView.width - assetInfo.popWidth,
                                    Math.max(space, gx))
                        assetInfo.y = Math.min(
                                    gridView.y + gridView.height - assetInfo.popHeight + space,
                                    Math.max(filterBar.height + space, gy))
                        assetInfo.pop.setID(entID)
                        assetInfo.pop.setTag(tag)
                        assetInfo.pop.setName(name)
                        assetInfo.pop.setInfo(info)
                        assetInfo.pop.setPath(path)
                        assetInfo.pop.setLink(link)
                        assetInfo.pop.setThumb(preset.host() + thumb)
                        assetInfo.pop.open()
                    }
                }
            }
        }
    }

    BusyIndicator {
        id: busy
        anchors.centerIn: parent
    }

    AssetInfo {
        id: assetInfo
    }

    Connections {
        target: header
        onProjectChanged: {
            busy.visible = true
            filterBar.visible = false
            filterLink.currentIndex = 0
            gridView.model = []
            assetInfo.pop.close()
            entityModel.update(
                        ["project", header.currentProject, "genus", "asset"])
        }
    }

    Connections {
        target: entityModel
        onDataChanged: {
            busy.visible = false
            filterBar.visible = true
            gridView.concurrent = 10
            gridView.model = entityModel
            acquired()
        }
    }
}
