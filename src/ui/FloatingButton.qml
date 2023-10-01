import QtQuick
import MemoPad.CommandManager
import "IO.js" as IO
import MemoPad.CardManager

Item {
    id: root
    width: 32
    height: 32

    property string imageSource: IconSet.blank
    property string buttonAction
    property alias actionEnabled: mouseArea.visible

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
        id: mouseArea
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
            else if (buttonAction === "back")
                IO.loadCanvas(CardManager.upperCanvasID())
        }
    }
}
