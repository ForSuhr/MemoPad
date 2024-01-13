import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import MemoPad.Globals
import MemoPad.IconSet

Item {
    id: root
    x: floatingBar.x
    y: floatingBar.y
    width: floatingBar.width
    height: floatingBar.height

    property int floatingBarItemWidth: 50
    property int floatingBarItemHeight: floatingBarItemWidth
    property int floatingBarItemNumber: 6 // depends on how many items inside the RowLayout
    property string floatingBarColor: "white"
    property string floatingBarPressedColor: "ghostwhite"
    property string floatingBarBorderColor: "gainsboro"
    property string topAreaKey: "top area"
    property string bottomAreaKey: "bottom area"
    property string floatingBarArea: Globals.floatingBarArea

    Drag.active: dragArea.drag.active
    Drag.keys: [topAreaKey, bottomAreaKey]

    Component.onCompleted: {
        if (floatingBarArea === "bottom area") {
            root.x = bottomArea.x + (bottomArea.width - floatingBar.width) / 2
            root.y = bottomArea.y + (bottomArea.height - floatingBar.height) / 2
        } else {
            root.x = topArea.x + (topArea.width - floatingBar.width) / 2
            root.y = topArea.y + (topArea.height - floatingBar.height) / 2
        }
    }

    Pane {
        id: floatingBar
        width: floatingBarItemWidth * floatingBarItemNumber
        height: floatingBarItemHeight
        opacity: enabled
        background: Rectangle {
            opacity: enabled ? 1 : 0.5
            radius: 15
            color: floatingBarColor
            border.color: floatingBarBorderColor
            border.width: 4
        }
        RowLayout {
            width: floatingBar.width - 18
            height: 32
            anchors.verticalCenter: parent.verticalCenter
            FloatingBarItem {
                id: canvasItem
                implicitWidth: parent.height
                implicitHeight: parent.height
                componentFile: "../nodes/CanvasCard.qml"
                imageSource: IconSet.canvas
            }
            FloatingBarItem {
                id: noteItem
                implicitWidth: parent.height
                implicitHeight: parent.height
                componentFile: "../nodes/NoteCard.qml"
                imageSource: IconSet.note
            }
            FloatingBarItem {
                id: imageItem
                implicitWidth: parent.height
                implicitHeight: parent.height
                componentFile: "../nodes/ImageCard.qml"
                imageSource: IconSet.image
            }
            FloatingBarItem {
                id: arrowItem
                implicitWidth: parent.height
                implicitHeight: parent.height
                componentFile: "../edges/Arrow.qml"
                imageSource: IconSet.arrow
            }
            FloatingBarItem {
                id: paletteItem
                implicitWidth: parent.height
                implicitHeight: parent.height
                imageSource: IconSet.palette
                enableMouseArea: false
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: canvasPalette.forceActiveFocus()
                    onEntered: {
                        cursorShape = Qt.PointingHandCursor
                        paletteItem.scale = 1.1
                    }
                    onExited: {
                        cursorShape = Qt.ArrowCursor
                        paletteItem.scale = 1
                    }
                }
            }
            FloatingBarItem {
                id: gearItem
                implicitWidth: parent.height
                implicitHeight: parent.height
                imageSource: IconSet.gear
                enableMouseArea: false
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: preferencesPopup.visible = true
                    onEntered: {
                        cursorShape = Qt.PointingHandCursor
                        rotationAnimation.start()
                    }
                    onExited: {
                        cursorShape = Qt.ArrowCursor
                        rotationAnimation.stop()
                    }
                }
                RotationAnimation {
                    id: rotationAnimation
                    target: gearItem
                    loops: Animation.Infinite
                    direction: RotationAnimation.Clockwise
                    from: parent.rotation
                    to: 360
                    duration: 3000
                }
            }
            Rectangle {
                id: dragAreaRect
                implicitWidth: parent.height
                implicitHeight: parent.height
                radius: 10
                border.width: 2
                border.color: "whitesmoke"
                color: "lightgray"
                MouseArea {
                    id: dragArea
                    anchors.fill: dragAreaRect
                    drag.target: root
                    drag.minimumX: 0
                    drag.minimumY: 0
                    drag.maximumX: root.parent.width - root.width
                    drag.maximumY: root.parent.height - root.height
                    hoverEnabled: true
                    property real currentX: 0
                    property real currentY: 0
                    onPressed: {
                        cursorShape = Qt.ClosedHandCursor
                        dragAreaRect.forceActiveFocus()
                        topArea.visible = true
                        bottomArea.visible = true
                        floatingBar.background.color = floatingBarPressedColor
                        currentX = root.x
                        currentY = root.y
                    }
                    onReleased: {
                        cursorShape = Qt.ArrowCursor
                        topArea.visible = false
                        bottomArea.visible = false
                        floatingBar.background.color = floatingBarColor
                        // recovery the position if a drag action was not accepted by a drop area
                        if (root.Drag.drop() !== Qt.MoveAction) {
                            root.x = currentX
                            root.y = currentY
                        }
                    }
                    onEntered: cursorShape = Qt.OpenHandCursor
                    onExited: cursorShape = Qt.ArrowCursor
                }
            }
        }

        Behavior on x {
            SmoothedAnimation {
                velocity: 2000
            }
        }

        Behavior on y {
            SmoothedAnimation {
                velocity: 2000
            }
        }
    }

    DropShadow {
        anchors.fill: floatingBar
        source: floatingBar
        radius: 6
        color: "gainsboro"
        smooth: true
    }
}
