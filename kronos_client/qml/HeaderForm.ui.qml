import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

Rectangle {
    id: item1
    height: 50
    color: "#363636"
    property alias loginBtn: loginBtn
    property alias projectCB: comboBox
    property alias projectLbl: text1
    property alias closeBtn: closeBtn
    property alias background: item1.color
    property alias comboEnabled: comboBox.enabled

    RowLayout {
        id: rowLayout
        anchors.fill: parent
        spacing: 20

        ComboBox {
            id: comboBox
            //height: 30
            enabled: false
            font.family: qsTr("微软雅黑")
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            Layout.fillHeight: true
            anchors.leftMargin: 5
        }

        Text {
            id: text1
            color: "darkgray"
            anchors.margins: 10
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            font.family: qsTr("微软雅黑")
            Layout.fillHeight: true
            font.weight: Font.Bold
            Layout.fillWidth: true
            font.pixelSize: 17
            text: qsTr("正在连接...")
        }

        ToolButton {
            id: loginBtn
            text: qsTr("登录")
            font.weight: Font.Bold
            font.pointSize: 12
            font.family: qsTr("微软雅黑")
        }

        ToolButton {
            id: closeBtn
            Image {
                anchors.fill: parent
                source: "exit.png"
            }
        }
    }
}
