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

    ScaleAnimator {
        id: scaleUp
        from: 1
        to: 1.1
        duration: 100
    }
    ScaleAnimator {
        id: scaleDown
        from: 1.1
        to: 1
        duration: 100
    }

    RowLayout {
        id: rowLayout
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
            width: rowLayout.height
            height: rowLayout.height
            radius: width / 2
            border.width: 2
            border.color: "lightgray"
            color: "mistyrose"
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: palette.parent.cardBackgroundColor = parent.color
                onEntered: {
                    scaleUp.target = parent
                    scaleUp.start()
                    cursorShape = Qt.PointingHandCursor
                }
                onExited: {
                    scaleDown.target = parent
                    scaleDown.start()
                    cursorShape = Qt.ArrowCursor
                }
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
                hoverEnabled: true
                onClicked: palette.parent.cardBackgroundColor = parent.color
                onEntered: {
                    scaleUp.target = parent
                    scaleUp.start()
                    cursorShape = Qt.PointingHandCursor
                }
                onExited: {
                    scaleDown.target = parent
                    scaleDown.start()
                    cursorShape = Qt.ArrowCursor
                }
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
                hoverEnabled: true
                onClicked: palette.parent.cardBackgroundColor = parent.color
                onEntered: {
                    scaleUp.target = parent
                    scaleUp.start()
                    cursorShape = Qt.PointingHandCursor
                }
                onExited: {
                    scaleDown.target = parent
                    scaleDown.start()
                    cursorShape = Qt.ArrowCursor
                }
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
                hoverEnabled: true
                onClicked: palette.parent.cardBackgroundColor = parent.color
                onEntered: {
                    scaleUp.target = parent
                    scaleUp.start()
                    cursorShape = Qt.PointingHandCursor
                }
                onExited: {
                    scaleDown.target = parent
                    scaleDown.start()
                    cursorShape = Qt.ArrowCursor
                }
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
                hoverEnabled: true
                onClicked: palette.parent.cardBackgroundColor = parent.color
                onEntered: {
                    scaleUp.target = parent
                    scaleUp.start()
                    cursorShape = Qt.PointingHandCursor
                }
                onExited: {
                    scaleDown.target = parent
                    scaleDown.start()
                    cursorShape = Qt.ArrowCursor
                }
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
                hoverEnabled: true
                onClicked: palette.parent.cardBackgroundColor = parent.color
                onEntered: {
                    scaleUp.target = parent
                    scaleUp.start()
                    cursorShape = Qt.PointingHandCursor
                }
                onExited: {
                    scaleDown.target = parent
                    scaleDown.start()
                    cursorShape = Qt.ArrowCursor
                }
            }
        }
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
