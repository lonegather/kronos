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

        }

        anchors.fill: parent
    }

    Component {
        id: detail
        Rectangle {
            color: "#00000000"
            Button {
                anchors.centerIn: parent
                text: "Pop"
                enabled: stack.depth > 1
                onClicked: stack.pop()
            }
            Component.onCompleted: {

            }
        }
    }


}
