import QtQuick
import "Snap.js" as Snap

Item {
    id: root

    property bool isVisble: false
    property real minHeight: 50
    property real minWidth: 50
    property real maxHeight: 1000
    property real maxWidth: 1000
    property int areaBorderWidth: 6
    property string areaBorderColor: "lightgray"
    property string areaColor: "transparent"
    property string dotColor: "gray"
    property int dotSize: 15

    /*select area*/
    Rectangle {
        id: selectAreaRect
        z: 2
        width: root.width
        height: root.height
        border.width: areaBorderWidth
        border.color: areaBorderColor
        color: areaColor
        opacity: 1
        radius: 10
        visible: isVisble
    }

    /*dots for resize*/
    Rectangle {
        id: topDot
        z: 2
        width: dotSize
        height: dotSize
        radius: dotSize / 2
        color: dotColor
        visible: isVisble
        anchors.horizontalCenter: selectAreaRect.horizontalCenter
        anchors.verticalCenter: selectAreaRect.top
        anchors.verticalCenterOffset: selectAreaRect.border.width / 2

        MouseArea {
            anchors.fill: parent
            drag.target: parent
            drag.axis: Drag.YAxis
            onPressed: cursorShape = Qt.ClosedHandCursor
            onReleased: cursorShape = Qt.ArrowCursor
            onMouseYChanged: {
                if (drag.active) {
                    root.height -= mouseY
                    root.y += mouseY
                    // set minimum and maximum of height
                    root.height = Math.max(minHeight, Math.min(maxHeight,
                                                               root.height))
                }
            }
        }
    }

    Rectangle {
        id: bottomDot
        z: 2
        width: dotSize
        height: dotSize
        radius: dotSize / 2
        color: dotColor
        visible: isVisble
        anchors.horizontalCenter: selectAreaRect.horizontalCenter
        anchors.verticalCenter: selectAreaRect.bottom
        anchors.verticalCenterOffset: -selectAreaRect.border.width / 2

        MouseArea {
            anchors.fill: parent
            drag.target: parent
            drag.axis: Drag.YAxis
            onPressed: cursorShape = Qt.ClosedHandCursor
            onReleased: cursorShape = Qt.ArrowCursor
            onMouseYChanged: {
                if (drag.active) {
                    root.height += mouseY
                    // set minimum and maximum of height
                    root.height = Math.max(minHeight, Math.min(maxHeight,
                                                               root.height))
                }
            }
        }
    }

    Rectangle {
        id: leftDot
        z: 2
        width: dotSize
        height: dotSize
        radius: dotSize / 2
        color: dotColor
        visible: isVisble
        anchors.horizontalCenter: selectAreaRect.left
        anchors.horizontalCenterOffset: selectAreaRect.border.width / 2
        anchors.verticalCenter: selectAreaRect.verticalCenter

        MouseArea {
            anchors.fill: parent
            drag.target: parent
            drag.axis: Drag.XAxis
            onPressed: cursorShape = Qt.ClosedHandCursor
            onReleased: cursorShape = Qt.ArrowCursor
            onMouseXChanged: {
                if (drag.active) {
                    root.width -= mouseX
                    root.x += mouseX
                    // set minimum and maximum of width
                    root.width = Math.max(minWidth, Math.min(maxWidth,
                                                             root.width))
                }
            }
        }
    }

    Rectangle {
        id: rightDot
        z: 2
        width: dotSize
        height: dotSize
        radius: dotSize / 2
        color: dotColor
        visible: isVisble
        anchors.horizontalCenter: selectAreaRect.right
        anchors.horizontalCenterOffset: -selectAreaRect.border.width / 2
        anchors.verticalCenter: selectAreaRect.verticalCenter

        MouseArea {
            anchors.fill: parent
            drag.target: parent
            drag.axis: Drag.XAxis
            onPressed: cursorShape = Qt.ClosedHandCursor
            onReleased: cursorShape = Qt.ArrowCursor
            onMouseXChanged: {
                if (drag.active) {
                    root.width += mouseX
                    // set minimum and maximum of width
                    root.width = Math.max(minWidth, Math.min(maxWidth,
                                                             root.width))
                }
            }
        }
    }
}
