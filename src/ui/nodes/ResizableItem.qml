import QtQuick
import "../js/Snap.js" as Snap
import "../js/IO.js" as IO
import MemoPad.CardManager
import MemoPad.CommandManager
import MemoPad.Globals

/* ResizableItem works as an abstract base item for other cards */
Item {
    id: root

    property bool isVisble: false
    property real minHeight: Globals.dotInterval * 3
    property real minWidth: Globals.dotInterval * 3
    property real maxHeight: Globals.dotInterval * 50
    property real maxWidth: Globals.dotInterval * 50
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
            hoverEnabled: true
            onEntered: cursorShape = Qt.SizeVerCursor
            onExited: cursorShape = Qt.ArrowCursor
            onReleased: {
                Snap.snap(root)
                IO.saveTransform(cardID, root)
            }
            onMouseYChanged: {
                if (drag.active) {
                    if (root.height > minHeight | mouseY < 0) {
                        root.height -= mouseY
                        root.y += mouseY
                        // set minimum and maximum of height
                        root.height = Math.max(minHeight, Math.min(maxHeight,
                                                                   root.height))
                    }
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
            hoverEnabled: true
            onEntered: cursorShape = Qt.SizeVerCursor
            onExited: cursorShape = Qt.ArrowCursor
            onReleased: {
                Snap.snap(root)
                IO.saveTransform(cardID, root)
            }
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
            hoverEnabled: true
            onEntered: cursorShape = Qt.SizeHorCursor
            onExited: cursorShape = Qt.ArrowCursor
            onReleased: {
                Snap.snap(root)
                IO.saveTransform(cardID, root)
            }
            onMouseXChanged: {
                if (drag.active) {
                    if (root.width > minWidth | mouseX < 0) {
                        root.width -= mouseX
                        root.x += mouseX
                        // set minimum and maximum of width
                        root.width = Math.max(minWidth, Math.min(maxWidth,
                                                                 root.width))
                    }
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
            hoverEnabled: true
            onEntered: cursorShape = Qt.SizeHorCursor
            onExited: cursorShape = Qt.ArrowCursor
            onReleased: {
                Snap.snap(root)
                IO.saveTransform(cardID, root)
            }
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

    Rectangle {
        id: topLeftDot
        z: 2
        width: dotSize
        height: dotSize
        radius: dotSize / 2
        color: dotColor
        visible: isVisble
        anchors.horizontalCenter: selectAreaRect.left
        anchors.horizontalCenterOffset: selectAreaRect.border.width / 2
        anchors.verticalCenter: selectAreaRect.top
        anchors.verticalCenterOffset: selectAreaRect.border.width / 2

        MouseArea {
            anchors.fill: parent
            drag.target: parent
            hoverEnabled: true
            onEntered: cursorShape = Qt.SizeFDiagCursor
            onExited: cursorShape = Qt.ArrowCursor
            onReleased: {
                Snap.snap(root)
                IO.saveTransform(cardID, root)
            }
            onMouseXChanged: {
                if (drag.active) {
                    if (root.width > minWidth | mouseX < 0) {
                        root.width -= mouseX
                        root.x += mouseX
                        // set minimum and maximum of width
                        root.width = Math.max(minWidth, Math.min(maxWidth,
                                                                 root.width))
                    }
                }
            }

            onMouseYChanged: {
                if (drag.active) {
                    if (root.height > minHeight | mouseY < 0) {
                        root.height -= mouseY
                        root.y += mouseY
                        // set minimum and maximum of height
                        root.height = Math.max(minHeight, Math.min(maxHeight,
                                                                   root.height))
                    }
                }
            }
        }
    }

    Rectangle {
        id: bottomLeftDot
        z: 2
        width: dotSize
        height: dotSize
        radius: dotSize / 2
        color: dotColor
        visible: isVisble
        anchors.horizontalCenter: selectAreaRect.left
        anchors.horizontalCenterOffset: selectAreaRect.border.width / 2
        anchors.verticalCenter: selectAreaRect.bottom
        anchors.verticalCenterOffset: -selectAreaRect.border.width / 2

        MouseArea {
            anchors.fill: parent
            drag.target: parent
            hoverEnabled: true
            onEntered: cursorShape = Qt.SizeBDiagCursor
            onExited: cursorShape = Qt.ArrowCursor
            onReleased: {
                Snap.snap(root)
                IO.saveTransform(cardID, root)
            }
            onMouseXChanged: {
                if (drag.active) {
                    if (root.width > minWidth | mouseX < 0) {
                        root.width -= mouseX
                        root.x += mouseX
                        // set minimum and maximum of width
                        root.width = Math.max(minWidth, Math.min(maxWidth,
                                                                 root.width))
                    }
                }
            }

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
        id: topRightDot
        z: 2
        width: dotSize
        height: dotSize
        radius: dotSize / 2
        color: dotColor
        visible: isVisble
        anchors.horizontalCenter: selectAreaRect.right
        anchors.horizontalCenterOffset: -selectAreaRect.border.width / 2
        anchors.verticalCenter: selectAreaRect.top
        anchors.verticalCenterOffset: selectAreaRect.border.width / 2

        MouseArea {
            anchors.fill: parent
            drag.target: parent
            hoverEnabled: true
            onEntered: cursorShape = Qt.SizeBDiagCursor
            onExited: cursorShape = Qt.ArrowCursor
            onReleased: {
                Snap.snap(root)
                IO.saveTransform(cardID, root)
            }
            onMouseXChanged: {
                if (drag.active) {
                    root.width += mouseX
                    // set minimum and maximum of width
                    root.width = Math.max(minWidth, Math.min(maxWidth,
                                                             root.width))
                }
            }

            onMouseYChanged: {
                if (drag.active) {
                    if (root.height > minHeight | mouseY < 0) {
                        root.height -= mouseY
                        root.y += mouseY
                        // set minimum and maximum of height
                        root.height = Math.max(minHeight, Math.min(maxHeight,
                                                                   root.height))
                    }
                }
            }
        }
    }

    Rectangle {
        id: bottomRightDot
        z: 2
        width: dotSize
        height: dotSize
        radius: dotSize / 2
        color: dotColor
        visible: isVisble
        anchors.horizontalCenter: selectAreaRect.right
        anchors.horizontalCenterOffset: -selectAreaRect.border.width / 2
        anchors.verticalCenter: selectAreaRect.bottom
        anchors.verticalCenterOffset: -selectAreaRect.border.width / 2

        MouseArea {
            anchors.fill: parent
            drag.target: parent
            hoverEnabled: true
            onEntered: cursorShape = Qt.SizeFDiagCursor
            onExited: cursorShape = Qt.ArrowCursor
            onReleased: {
                Snap.snap(root)
                IO.saveTransform(cardID, root)
            }
            onMouseXChanged: {
                if (drag.active) {
                    root.width += mouseX
                    // set minimum and maximum of width
                    root.width = Math.max(minWidth, Math.min(maxWidth,
                                                             root.width))
                }
            }

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
}
