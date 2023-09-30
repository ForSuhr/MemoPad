import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root

    signal floatingBarAreaChangedUI(string area)

    property string floatingBarColor: "white"
    property string floatingBarPressedColor: "ghostwhite"
    property string floatingBarBorderColor: "gainsboro"
    property string topAreaKey: "top area"
    property string bottomAreaKey: "bottom area"
    property string floatingBarArea: "top area" // area read from settings
    property var defaultArea: topArea

    FloatingBarArea {
        id: topArea
        x: root.x
        y: root.y
        width: root.parent.width
        height: root.parent.height / 6
        visible: false
        key: topAreaKey
        onFloatingBarDropped: {
            floatingBar.x = topArea.x + (topArea.width - floatingBar.width) / 2
            floatingBar.y = topArea.y + (topArea.height - floatingBar.height) / 2
            floatingBarAreaChangedUI(topAreaKey)
        }
    }

    FloatingBarArea {
        id: bottomArea
        x: root.x
        y: root.y + root.height * 5 / 6
        width: root.parent.width
        height: root.parent.height / 6
        visible: false
        key: bottomAreaKey
        onFloatingBarDropped: {
            floatingBar.x = bottomArea.x + (bottomArea.width - floatingBar.width) / 2
            floatingBar.y = bottomArea.y + (bottomArea.height - floatingBar.height) / 2
            floatingBarAreaChangedUI(bottomAreaKey)
        }
    }

    Pane {
        id: floatingBar
        width: 50 * 4 // depends on how many items inside the RowLayout
        height: 50
        x: floatingBarArea
           === "bottom area" ? bottomArea.x + (bottomArea.width - floatingBar.width)
                               / 2 : defaultArea.x + (defaultArea.width - floatingBar.width) / 2
        y: floatingBarArea
           === "bottom area" ? bottomArea.y + (bottomArea.height - floatingBar.height)
                               / 2 : defaultArea.y + (defaultArea.height - floatingBar.height) / 2
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
                floatingBarArea: root.floatingBarArea
                componentFile: "CanvasCard.qml"
                imageSource: IconSet.canvas
            }
            FloatingBarItem {
                id: noteItem
                implicitWidth: parent.height
                implicitHeight: parent.height
                floatingBarArea: root.floatingBarArea
                componentFile: "NoteCard.qml"
                imageSource: IconSet.note
            }
            Item {
                id: spacerItem
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
            FloatingBarItem {
                id: gearItem
                implicitWidth: parent.height
                implicitHeight: parent.height
                imageSource: IconSet.gear
                floatingBarArea: root.floatingBarArea
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
                    drag.target: floatingBar
                    drag.minimumX: 0
                    drag.minimumY: 0
                    drag.maximumX: root.parent.width - floatingBar.width
                    drag.maximumY: root.parent.height - floatingBar.height
                    hoverEnabled: true
                    property real currentX: 0
                    property real currentY: 0
                    onPressed: {
                        cursorShape = Qt.ClosedHandCursor
                        topArea.visible = true
                        bottomArea.visible = true
                        floatingBar.background.color = floatingBarPressedColor
                        currentX = floatingBar.x
                        currentY = floatingBar.y
                    }
                    onReleased: {
                        cursorShape = Qt.ArrowCursor
                        topArea.visible = false
                        bottomArea.visible = false
                        floatingBar.background.color = floatingBarColor
                        // recovery the position if a drag action was not accepted by a drop area
                        if (floatingBar.Drag.drop() !== Qt.MoveAction) {
                            floatingBar.x = currentX
                            floatingBar.y = currentY
                        }
                    }
                    onEntered: cursorShape = Qt.OpenHandCursor
                    onExited: cursorShape = Qt.ArrowCursor
                }
            }
        }

        Drag.active: dragArea.drag.active
        Drag.keys: [topAreaKey, bottomAreaKey]

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

    /*settings window*/
    PreferencesPopup {
        id: preferencesPopup
    }

    /*undo&redo button*/
    FloatingButton {
        id: undo
        x: 42
        y: root.height - height - 42
        width: 32
        height: 32
        imageSource: IconSet.undo
        buttonAction: "undo"
    }

    FloatingButton {
        id: redo
        x: root.width - width - 42
        y: root.height - height - 42
        width: 32
        height: 32
        imageSource: IconSet.redo
        buttonAction: "redo"
    }
}
