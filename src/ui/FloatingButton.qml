import QtQuick
import MemoPad.CommandManager

Item {
    id: root
    width: 32
    height: 32

    property string imageSource: IconSet.blank
    property string buttonAction

    Image {
        id: img
        width: parent.width
        height: parent.height
        anchors.fill: parent
        source: imageSource
        mipmap: true
        opacity: 0.4
        scale: 0.9
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            cursorShape = Qt.PointingHandCursor
            img.opacity = 0.8
            img.scale = 1
        }
        onExited: {
            cursorShape = Qt.ArrowCursor
            img.opacity = 0.4
            img.scale = 0.9
        }
        onClicked: {
            if (buttonAction === "undo")
                CommandManager.undo()
            else if (buttonAction === "redo")
                CommandManager.redo()
        }
    }
}
