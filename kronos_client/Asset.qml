import QtQuick 2.0
import QtQuick.Controls 2.0

Item {
    anchors.rightMargin: 5
    anchors.leftMargin: 5
    anchors.bottomMargin: 5
    anchors.topMargin: 5
    anchors.fill: parent

    StackView {
        id: stack
        initialItem: AssetBrief {
            id: asset
        }
        anchors.fill: parent
    }

    Component {
        id: detail
        Rectangle {
            color: "#00000000"
            Button {
                text: "Pop"
                anchors.centerIn: parent
                enabled: stack.depth > 1
                onClicked: stack.pop()
            }
            Component.onCompleted: {
                var name = JSON.parse(entityModel.analyze(asset.view.currentIndex, "name"))
                var info = JSON.parse(entityModel.analyze(asset.view.currentIndex, "info"))
                var path = JSON.parse(entityModel.analyze(asset.view.currentIndex, "path"))
                var tag = JSON.parse(entityModel.analyze(asset.view.currentIndex, "tag"))
                var tagInfo = JSON.parse(entityModel.analyze(asset.view.currentIndex, "tag_info"))
                console.log(name)
                console.log(info)
                console.log(tag)
                console.log(tagInfo)
            }
        }
    }


}
