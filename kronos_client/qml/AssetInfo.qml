import QtQuick 2.7
import QtQuick.Controls 2.2

Item {
    property alias pop: pop
    //state: "edit"

    states: [
        State {
            name: "edit"
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
            }
            PropertyChanges {
                target: popInfo
                visible: false
            }
            PropertyChanges {
                target: popInfoInput
                visible: true
            }
        }
    ]

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
                            visible: false
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
                        Label {
                            id: popInfo
                            anchors.fill: parent
                            color: "darkgray"
                            font.pixelSize: 15
                            font.family: qsTr("微软雅黑")
                            wrapMode: Text.WordWrap
                        }
                        TextArea {
                            id: popInfoInput
                            visible: false
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
                        ToolButton {
                            id: editBtn
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

        MouseArea {
            anchors.fill: parent
            property point init: "0,0"
            onPressed: {
                init = Qt.point(mouse.x, mouse.y)
            }
            onPositionChanged: {
                var delta = Qt.point(mouse.x - init.x, mouse.y - init.y)
                pop.x = pop.x + delta.x
                pop.y = pop.y + delta.y
            }
        }
    }
}
