import QtQuick
import QtQuick.Controls

Item {
    id: root
    width: 500
    height: 200

    ToolBar {
        id: toolBar
        anchors.fill: parent
        opacity: enabled
        background: Rectangle {
            id: bgRect
            implicitWidth: root.width
            implicitHeight: root.height
            opacity: enabled ? 1 : 0.5
            radius: 15
            color: "white"
            border.color: "whitesmoke"
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        drag.target: root
        drag.minimumX: 0
        drag.minimumY: 0
        drag.maximumX: root.parent.width - root.width
        drag.maximumY: root.parent.height - root.height
    }
}
