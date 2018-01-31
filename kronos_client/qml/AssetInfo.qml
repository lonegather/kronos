import QtQuick 2.7
import QtQuick.Controls 2.2

Item {
    id: popRoot
    property alias pop: pop
    property real popWidth: 506
    property real popHeight: 319

    onStateChanged: {
        if (state === "new") {
            tagCombo.currentIndex = 0
            pop.setLink("[]")
        } else if (state === "edit") {
            popNameInput.placeholderText = popName.text
            popInfoInput.placeholderText = popInfo.text
            for (var i = 0; i < tagModel.count; i++) {
                if (tagModel.get(i)["name"] === tagCombo.tag) {
                    tagCombo.currentIndex = i
                }
            }
        }
    }

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
                visible: auth.role() === "administrator" || auth.role() === "producer"
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
            PropertyChanges {
                target: thumbBtn
                state: ""
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
                placeholderText: qsTr("新建资产...")
            }
            PropertyChanges {
                target: popInfo
                visible: false
            }
            PropertyChanges {
                target: popInfoInput
                visible: true
                text: ""
                placeholderText: qsTr("资产描述...")
            }
            PropertyChanges {
                target: tagCombo
                currentIndex: -1
            }
            PropertyChanges {
                target: thumb
                source: "http://" + preset.host() + "/media/thumbs/default.png"
                origin: "http://" + preset.host() + "/media/thumbs/default.png"
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
                placeholderText: popName.text
            }
            PropertyChanges {
                target: popInfo
                visible: false
            }
            PropertyChanges {
                target: popInfoInput
                visible: true
                text: popInfo.text
                placeholderText: popInfo.text
            }
        }
    ]

    Popup {
        id: pop
        width: parent.popWidth
        height: parent.popHeight
        modal: false
        focus: true
        onClosed: {
            parent.state = ""
        }

        property string identity: ""

        function setID(str) {
            identity = str
        }

        function setTag(str) {
            tagCombo.tag = str
        }

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

        function setLink(str) {
            var presetBatch = JSON.parse(preset.data("batch"))
            linkModel.clear()
            for (var i in presetBatch) {
                if (presetBatch[i]["project"] === header.currentProject) {
                    var currentLink = JSON.parse(str)
                    var hasConnection = false
                    for (var l in currentLink) {
                        if (currentLink[l] === presetBatch[i]["id"]) {
                            hasConnection = true
                        }
                    }

                    linkModel.append({
                                         linkID: presetBatch[i]["id"],
                                         linkName: presetBatch[i]["name"],
                                         linkExists: hasConnection
                                     })
                }
            }
            linkView.model = linkModel
        }

        function setThumb(str) {
            thumb.origin = str
            thumb.source = str
        }

        ListModel {
            id: pathModel
        }

        Column {
            id: popBrief
            anchors.margins: 5
            anchors.fill: parent
            Row {
                id: bio
                spacing: 10
                width: parent.width
                height: 128
                Rectangle {
                    color: "#00000000"
                    width: height
                    height: parent.height

                    Image {
                        id: thumb
                        anchors.fill: parent
                        sourceSize.width: 128
                        sourceSize.height: 128
                        property string origin: ""
                    }
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
                        color: "#00000000"
                        width: parent.width
                        height: width
                        ToolButton {
                            id: exitBtn
                            anchors.fill: parent
                            Image {
                                anchors.fill: parent
                                source: "exit.png"
                            }
                            onClicked: {
                                pop.close()
                            }
                        }
                    }
                    Rectangle {
                        id: edit
                        color: "#00000000"
                        width: parent.width
                        height: width
                        visible: false
                        ToolButton {
                            id: editBtn
                            anchors.fill: parent
                            Image {
                                anchors.fill: parent
                                source: "edit.png"
                            }
                            onClicked: {
                                pop.parent.state = "edit"
                            }
                        }
                    }
                    Rectangle {
                        id: confirm
                        visible: false
                        color: "#00000000"
                        width: parent.width
                        height: width
                        ToolButton {
                            id: confirmBtn
                            anchors.fill: parent
                            Image {
                                anchors.fill: parent
                                source: "confirm.png"
                            }
                            onClicked: {
                                var form = JSON.parse("{}")

                                if (popRoot.state === "edit") {
                                    form["id"] = pop.identity
                                }
                                form["project"] = header.currentProjectID
                                form["name"] = popNameInput.text
                                form["info"] = popInfoInput.text
                                form["tag"] = tagModel.get(
                                            tagCombo.currentIndex)["name"]
                                form["link"] = []
                                for (var i = 0; i < linkModel.count; i++) {
                                    var item = linkModel.get(i)
                                    if (item["linkExists"]) {
                                        form["link"].push(item["linkID"])
                                    }
                                }
                                if (thumbBtn.state === "restore") {
                                    form["file"] = screenshot.file(popNameInput.text)
                                }

                                busy.visible = true
                                filterBar.visible = false
                                filterLink.currentIndex = 0
                                gridView.model = []
                                pop.close()
                                entityModel.set_asset(JSON.stringify(form))
                            }
                        }
                    }
                    Rectangle {
                        id: cancel
                        visible: false
                        color: "#00000000"
                        width: parent.width
                        height: width
                        ToolButton {
                            id: cancelBtn
                            anchors.fill: parent
                            Image {
                                anchors.fill: parent
                                source: "cancel.png"
                            }
                            onClicked: {
                                thumb.cache = true
                                thumb.source = thumb.origin
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
                height: popBrief.height - bio.height
                orientation: Qt.Vertical
                interactive: false
                clip: true
                Rectangle {
                    color: "#00000000"
                    //anchors.topMargin: 5
                    ListView {
                        id: pathView
                        clip: true
                        spacing: 5
                        anchors.fill: parent
                        anchors.topMargin: 5
                        model: pathModel
                        flickableDirection: Flickable.AutoFlickIfNeeded
                        delegate: Item {
                            width: parent.width
                            height: 50
                            clip: true
                            Rectangle {
                                anchors.fill: parent
                                radius: 3
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
                Rectangle {
                    radius: 3
                    color: "#00000000"
                    Column {
                        anchors.fill: parent
                        Row {
                            id: labelRow
                            width: parent.width
                            height: 40
                            Rectangle {
                                id: linkLabelRec
                                color: "#00000000"
                                width: 128
                                height: parent.height
                                Button {
                                    id: thumbBtn
                                    anchors.fill: parent
                                    text: qsTr("修改缩略图")
                                    font.pointSize: 12
                                    font.family: qsTr("微软雅黑")
                                    states: [
                                        State {
                                            name: ""
                                            PropertyChanges {
                                                target: thumbBtn
                                                text: qsTr("修改缩略图")
                                            }
                                        },

                                        State {
                                            name: "restore"
                                            PropertyChanges {
                                                target: thumbBtn
                                                text: qsTr("还原")
                                            }
                                        }
                                    ]
                                    onStateChanged: {
                                        if (state === "") {
                                            thumb.cache = true
                                            thumb.source = thumb.origin
                                        } else {
                                            screenshot.clear()
                                            thumb.cache = false
                                            thumb.source = "image://screenshot/"
                                        }
                                    }
                                    onClicked: {
                                        state = state ? "" : "restore"
                                    }
                                }
                            }

                            Rectangle {
                                id: spacerRec
                                color: "#00000000"
                                width: parent.width - tagLabelRec.width
                                       - tagComboRec.width - linkLabelRec.width - 3
                                height: parent.height
                            }

                            Rectangle {
                                id: tagLabelRec
                                width: 100
                                height: parent.height
                                color: linkLabelRec.color
                                Label {
                                    anchors.fill: parent
                                    text: qsTr("资产类型：")
                                    font.pointSize: 12
                                    font.family: qsTr("微软雅黑")
                                    horizontalAlignment: Text.AlignRight
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }
                            Rectangle {
                                id: tagComboRec
                                width: 100
                                height: parent.height
                                color: linkLabelRec.color
                                ListModel {
                                    id: tagModel
                                }

                                ComboBox {
                                    id: tagCombo
                                    font.family: qsTr("微软雅黑")
                                    anchors.fill: parent
                                    property string tag: ""
                                }
                            }
                        }

                        ListModel {
                            id: linkModel
                        }

                        Rectangle {
                            color: "#33000000"
                            width: parent.width
                            height: parent.height - labelRow.height
                            GridView {
                                id: linkView
                                anchors.fill: parent
                                delegate: Rectangle {
                                    color: "#00000000"
                                    width: 80
                                    height: 35
                                    CheckBox {
                                        id: linkCheck
                                        font.pointSize: 10
                                        font.family: qsTr("微软雅黑")
                                        anchors.fill: parent
                                        text: linkName
                                        checked: linkExists
                                        onToggled: {
                                            linkExists = checked
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                Connections {
                    target: header
                    onProjectChanged: {
                        var presetTag = JSON.parse(preset.data("tag"))
                        tagModel.clear()
                        for (var i in presetTag) {
                            if (presetTag[i]["genus"] === "asset") {
                                tagModel.append({
                                                    name: presetTag[i]["name"],
                                                    modelData: presetTag[i]["info"]
                                                })
                            }
                        }
                        tagCombo.model = tagModel
                    }
                }

                Connections {
                    target: screenshot
                    onGrabbed: {
                        if (thumbBtn.state === "restore") {
                            thumb.source = "image://screenshot/."
                            thumb.source = "image://screenshot/"
                        }
                    }
                }
            }
        }
    }
    Connections {
        target: auth
        onGranted: {
            if (parent.state === "") {
                console.log("adasdfasdf")
                edit.visible = auth.role() === "administrator" || auth.role() === "producer"
            }
        }
        onExited: {
            if (parent.state === "") {
                edit.visible = auth.role() === "administrator" || auth.role() === "producer"
            }
        }
    }
}
