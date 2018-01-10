import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

Rectangle {
    id: item1
    height: 50
    color: "#363636"
    property alias projectCB: comboBox
    property alias projectLbl: text1
    property alias closeBtn: closeBtn

    RowLayout {
        id: rowLayout
        anchors.fill: parent
        spacing: 20

        ComboBox {
            id: comboBox
            height: 30
            font.family: qsTr("微软雅黑")
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 5
        }

        Text {
            id: text1
            anchors.margins: 10
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            font.family: qsTr("微软雅黑")
            color: "grey"
            Layout.fillHeight: true
            font.weight: Font.Bold
            style: Text.Raised
            Layout.fillWidth: true
            font.pixelSize: 18
        }

        ToolButton {
            id: closeBtn
            focusPolicy: Qt.NoFocus
        }
    }
}
