import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "IO.js" as IO

Pane {
    id: palette

    property int colorNum: 6
    property string borderColor: "gainsboro"

    width: 32 * colorNum
    height: 32
    anchors.horizontalCenter: palette.parent.horizontalCenter
    anchors.bottom: palette.parent.top
    anchors.bottomMargin: 10
    opacity: enabled
    visible: false
    background: Rectangle {
        opacity: enabled ? 1 : 0.5
        radius: 10
        color: "white"
        border.width: 2
        border.color: borderColor
    }

    RowLayout {
        width: 32 * colorNum - 16
        height: 24
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
        CardEditBarItem {
            width: parent.height
            height: parent.height
            imageSource: IconSet.trash
            MouseArea {
                anchors.fill: parent
                onClicked: IO.deleteCard(palette.parent.id, palette.parent)
            }
        }
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
