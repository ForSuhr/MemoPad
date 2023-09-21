import QtQuick
import QtQuick.Controls

Item {
    id: root

    property string toolBarColor: "white"
    property string toolBarPressedColor: "ghostwhite"
    property string toolBarBorderColor: "whitesmoke"
    property string topAreaKey: "top area"
    property string bottomAreaKey: "bottom area"
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
        }
    }

    ToolBar {
        id: toolBar
        width: 200
        height: 50
        x: defaultArea.x + (defaultArea.width - toolBar.width) / 2
        y: defaultArea.y + (defaultArea.height - toolBar.height) / 2
        opacity: enabled
        background: Rectangle {
            opacity: enabled ? 1 : 0.5
            radius: 15
            color: toolBarColor
            border.color: toolBarBorderColor
            border.width: 4
        }

        Drag.active: dragArea.drag.active
        Drag.keys: [topAreaKey, bottomAreaKey]

        Behavior on x {
            SmoothedAnimation {
                velocity: 1000
            }
        }

        Behavior on y {
            SmoothedAnimation {
                velocity: 1000
            }
        }

        MouseArea {
            id: dragArea
            anchors.fill: parent
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
