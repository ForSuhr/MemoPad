import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

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
    visible: true
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
        CardEditBarItem {
            width: parent.height
            height: parent.height
            imageSource: IconSet.trash
        }
    }
}
