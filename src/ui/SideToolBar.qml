import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root

    signal toolBarAreaChangedUI(string area)

    property string toolBarColor: "white"
    property string toolBarPressedColor: "ghostwhite"
    property string toolBarBorderColor: "whitesmoke"
    property string topAreaKey: "top area"
    property string bottomAreaKey: "bottom area"
    property string toolBarArea: "top area" // area read from settings
    property var defaultArea: topArea

    SideToolBarArea {
        id: topArea
        x: root.x
        y: root.y
        width: root.parent.width
        height: root.parent.height / 6
        visible: false
        key: topAreaKey
        onToolBarDropped: {
            toolBar.x = topArea.x + (topArea.width - toolBar.width) / 2
            toolBar.y = topArea.y + (topArea.height - toolBar.height) / 2
            toolBarAreaChangedUI(topAreaKey)
        }
    }

    SideToolBarArea {
        id: bottomArea
        x: root.x
        y: root.y + root.height * 5 / 6
        width: root.parent.width
        height: root.parent.height / 6
        visible: false
        key: bottomAreaKey
        onToolBarDropped: {
            toolBar.x = bottomArea.x + (bottomArea.width - toolBar.width) / 2
            toolBar.y = bottomArea.y + (bottomArea.height - toolBar.height) / 2
            toolBarAreaChangedUI(bottomAreaKey)
        }
    }

    Pane {
        id: toolBar
        width: 50 * 4 // depends on how many items inside the RowLayout
        height: 50
        x: toolBarArea
           === "bottom area" ? bottomArea.x + (bottomArea.width - toolBar.width)
                               / 2 : defaultArea.x + (defaultArea.width - toolBar.width) / 2
        y: toolBarArea
           === "bottom area" ? bottomArea.y + (bottomArea.height - toolBar.height)
                               / 2 : defaultArea.y + (defaultArea.height - toolBar.height) / 2
        opacity: enabled
        background: Rectangle {
            opacity: enabled ? 1 : 0.5
            radius: 15
            color: toolBarColor
            border.color: toolBarBorderColor
            border.width: 4
        }

        RowLayout {
            width: toolBar.width - 18
            height: toolBar.height - 18
            SideToolBarItem {
                id: canvasItem
                implicitWidth: parent.height
                implicitHeight: parent.height
                toolBarArea: root.toolBarArea
                componentFile: "CanvasCard.qml"
                imageSource: "assets/themes/lumos/canvas.svg"
            }
            SideToolBarItem {
                id: noteItem
                implicitWidth: parent.height
                implicitHeight: parent.height
                toolBarArea: root.toolBarArea
                componentFile: "NoteCard.qml"
                imageSource: "assets/themes/lumos/note.svg"
            }
            Item {
                id: spacerItem
                Layout.fillWidth: true
                Layout.fillHeight: true
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
                    drag.target: toolBar
                    drag.minimumX: 0
                    drag.minimumY: 0
                    drag.maximumX: root.parent.width - toolBar.width
                    drag.maximumY: root.parent.height - toolBar.height
                    property real currentX: 0
                    property real currentY: 0

                    onPressed: {
                        topArea.visible = true
                        bottomArea.visible = true
                        toolBar.background.color = toolBarPressedColor
                        currentX = toolBar.x
                        currentY = toolBar.y
                    }
                    onReleased: {
                        topArea.visible = false
                        bottomArea.visible = false
                        toolBar.background.color = toolBarColor
                        // recovery the position if a drag action was not accepted by a drop area
                        if (toolBar.Drag.drop() !== Qt.MoveAction) {
                            toolBar.x = currentX
                            toolBar.y = currentY
                        }
                    }
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
}
