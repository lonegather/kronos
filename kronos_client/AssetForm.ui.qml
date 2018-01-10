import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Item {
    property alias gridView: gridView
    anchors.fill: parent
    RowLayout {
        id: rowLayout
        anchors.rightMargin: 15
        anchors.leftMargin: 15
        anchors.bottomMargin: 15
        anchors.topMargin: 15
        spacing: 15
        anchors.fill: parent

        GridView {
            id: gridView
            anchors.fill: parent
            cellWidth: 138
            cellHeight: 157
            delegate: Item {
                width: gridView.cellWidth
                height: gridView.cellHeight
                Column {
                    spacing: 5
                    anchors.fill: parent
                    Rectangle {
                        width: 128
                        height: 128
                        color: "grey"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        text: display
                        color: "grey"
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.bold: true
                    }
                }
            }
        }

        ListView {
            Layout.fillHeight: true
        }
    }
}
