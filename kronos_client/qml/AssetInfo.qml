import QtQuick 2.7
import QtQuick.Controls 2.2

Item {
    property alias pop: pop
    property real popWidth: 506
    property real popHeight: 319

    states: [
        State {
            name: ""
            PropertyChanges {
                target: pop
                closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
            }
            PropertyChanges {
                target: popDetail
                currentIndex: 0
            }
            PropertyChanges {
                target: edit
                visible: true
            }
            PropertyChanges {
                target: exit
                visible: true
            }
            PropertyChanges {
                target: confirm
                visible: false
            }
            PropertyChanges {
                target: cancel
                visible: false
            }
            PropertyChanges {
                target: popName
                visible: true
            }
            PropertyChanges {
                target: popNameInput
                visible: false
                text: ""
            }
            PropertyChanges {
                target: popInfo
                visible: true
            }
            PropertyChanges {
                target: popInfoInput
                visible: false
                text: ""
            }
        },
        State {
            name: "new"
            PropertyChanges {
                target: pop
                closePolicy: Popup.NoAutoClose
            }
            PropertyChanges {
                target: popDetail
                currentIndex: 1
            }
            PropertyChanges {
                target: edit
                visible: false
            }
            PropertyChanges {
                target: exit
                visible: false
            }
            PropertyChanges {
                target: confirm
                visible: true
            }
            PropertyChanges {
                target: cancel
                visible: true
            }
            PropertyChanges {
                target: popName
                visible: false
            }
            PropertyChanges {
                target: popNameInput
                visible: true
                text: ""
            }
            PropertyChanges {
                target: popInfo
                visible: false
            }
            PropertyChanges {
                target: popInfoInput
                visible: true
                text: ""
            }
        },
        State {
            name: "edit"
            PropertyChanges {
                target: pop
                closePolicy: Popup.NoAutoClose
            }
            PropertyChanges {
                target: popDetail
                currentIndex: 1
            }
            PropertyChanges {
                target: edit
                visible: false
            }
            PropertyChanges {
                target: exit
                visible: false
            }
            PropertyChanges {
                target: confirm
                visible: true
            }
            PropertyChanges {
                target: cancel
                visible: true
            }
            PropertyChanges {
                target: popName
                visible: false
            }
            PropertyChanges {
                target: popNameInput
                visible: true
                text: popName.text
            }
            PropertyChanges {
                target: popInfo
                visible: false
            }
            PropertyChanges {
                target: popInfoInput
                visible: true
                text: popInfo.text
            }
        }
    ]

    Popup {
        id: pop
        width: parent.popWidth
        height: parent.popHeight
        modal: false
        focus: true

        function setName(str) {
            popName.text = str
        }

        function setInfo(str) {
            popInfo.text = str
        }

        function setPath(path) {
            var presetStage = JSON.parse(preset.data("stage"))
            var filteredStage = {

            }
            for (var i in presetStage) {
                if (presetStage[i]["project"] === header.currentProject) {
                    filteredStage[presetStage[i]["name"]] = presetStage[i]["info"]
                }
            }

            pathModel.clear()
            var pathDic = JSON.parse(path)
            for (i in pathDic) {
                pathModel.append({
                                     pathName: filteredStage[i],
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
                        color: "#00000000"
                        width: parent.width
                        height: 43
                        Label {
                            id: popName
                            visible: true
                            anchors.fill: parent
                            color: "darkgray"
                            lineHeight: 1.1
                            font.pixelSize: 20
                            font.family: qsTr("微软雅黑")
                            //verticalAlignment: TextInput.AlignVCenter
                        }
                        TextField {
                            id: popNameInput
                            visible: false
                            topPadding: 5
                            anchors.fill: parent
                            color: popName.color
                            font.pixelSize: popName.font.pixelSize
                            font.family: popName.font.family
                            //verticalAlignment: popName.verticalAlignment
                        }
                    }
                    Rectangle {
                        color: "#00000000"
                        width: parent.width
                        height: 85
                        Label {
                            id: popInfo
                            visible: true
                            topPadding: 5
                            anchors.fill: parent
                            color: "darkgray"
                            font.pixelSize: 15
                            font.family: qsTr("微软雅黑")
                            wrapMode: Text.WordWrap
                        }
                        TextArea {
                            id: popInfoInput
                            visible: false
                            topPadding: 5
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
                        id: exit
                        color: "#33000000"
                        width: parent.width
                        height: width
                        visible: true
                        ToolButton {
                            id: exitBtn
                            anchors.fill: parent
                            onClicked: {
                                pop.close()
                            }
                        }
                    }
                    Rectangle {
                        id: edit
                        color: "#33ffff00"
                        width: parent.width
                        height: width
                        visible: true
                        ToolButton {
                            id: editBtn
                            anchors.fill: parent
                            onClicked: {
                                pop.parent.state = "edit"
                            }
                        }
                    }
                    Rectangle {
                        id: confirm
                        visible: false
                        color: "#2200ff00"
                        width: parent.width
                        height: width
                        ToolButton {
                            id: confirmBtn
                            anchors.fill: parent
                        }
                    }
                    Rectangle {
                        id: cancel
                        visible: false
                        color: "#33ff0000"
                        width: parent.width
                        height: width
                        ToolButton {
                            id: cancelBtn
                            anchors.fill: parent
                            onClicked: {
                                if (pop.parent.state === "new") {
                                    pop.close()
                                } else {
                                    pop.parent.state = ""
                                }
                            }
                        }
                    }
                }
            }

            SwipeView {
                id: popDetail
                width: bio.width
                height: popBrief.height - bio.height - bio.spacing
                orientation: Qt.Vertical
                interactive: false
                clip: true
                ListView {
                    id: pathView
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
                Rectangle {
                    color: "#33000000"
                }
            }
        }
    }
}
