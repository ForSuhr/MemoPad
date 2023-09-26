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
    anchors.top: palette.parent.bottom
    anchors.topMargin: 10
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
        Rectangle {
            id: mistyrose
            width: parent.height
            height: parent.height
            radius: width / 2
            border.width: 2
            border.color: "lightgray"
            color: "mistyrose"
            MouseArea {
                anchors.fill: parent
                onClicked: palette.parent.cardBackgroundColor = parent.color
            }
        }
        Rectangle {
            id: aliceblue
            width: parent.height
            height: parent.height
            radius: width / 2
            border.width: 2
            border.color: "lightgray"
            color: "aliceblue"
            MouseArea {
                anchors.fill: parent
                onClicked: palette.parent.cardBackgroundColor = parent.color
            }
        }
        Rectangle {
            id: floralwhite
            width: parent.height
            height: parent.height
            radius: width / 2
            border.width: 2
            border.color: "lightgray"
            color: "floralwhite"
            MouseArea {
                anchors.fill: parent
                onClicked: palette.parent.cardBackgroundColor = parent.color
            }
        }
        Rectangle {
            id: mintcream
            width: parent.height
            height: parent.height
            radius: width / 2
            border.width: 2
            border.color: "lightgray"
            color: "mintcream"
            MouseArea {
                anchors.fill: parent
                onClicked: palette.parent.cardBackgroundColor = parent.color
            }
        }
        Rectangle {
            id: snow
            width: parent.height
            height: parent.height
            radius: width / 2
            border.width: 2
            border.color: "lightgray"
            color: "snow"
            MouseArea {
                anchors.fill: parent
                onClicked: palette.parent.cardBackgroundColor = parent.color
            }
        }
        Rectangle {
            id: whitesmoke
            width: parent.height
            height: parent.height
            radius: width / 2
            border.width: 2
            border.color: "lightgray"
            color: "whitesmoke"
            MouseArea {
                anchors.fill: parent
                onClicked: palette.parent.cardBackgroundColor = parent.color
            }
        }
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
