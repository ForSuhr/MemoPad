import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import MemoPad.CardManager
import MemoPad.CommandManager
import "Snap.js" as Snap
import "IO.js" as IO

ResizableItem {
    id: root
    width: Globals.dotInterval * 8
    height: Globals.dotInterval * 8

    property string id
    property string backgroundColor: "snow"
    property string borderColor: "gainsboro"
    property int borderWidth: 2
    property int cornerRadius: 10
    property alias imageSource: img.source

    property bool created: false
    property bool loaded: false
    property alias selected: imageFrame.focus

    onCreatedChanged: {
        id = CardManager.createCard("image")
        Snap.snap(root)
        IO.saveTransform(id, root, false)
        IO.saveBackgroundColor(id, root, false)
    }
    onLoadedChanged: {
        root.width = CardManager.width(id)
        root.height = CardManager.height(id)
        root.backgroundColor = CardManager.backgroundColor(id)
        root.imageSource = IconSet.image
        Snap.snap(root)
    }
    onSelectedChanged: {
        isVisble = selected
        mouseArea.enabled = !selected
        editBar.visible = selected
        palette.visible = selected
        root.parent.setCardToTop(id)
    }

    MouseArea {
        id: mouseArea
        z: 1
        anchors.fill: parent
        drag.target: root
        drag.minimumX: 0
        drag.minimumY: 0
        drag.maximumX: root.parent.width - root.width
        drag.maximumY: root.parent.height - root.height
        acceptedButtons: Qt.LeftButton
        hoverEnabled: true
        onEntered: cursorShape = Qt.OpenHandCursor
        onExited: cursorShape = Qt.ArrowCursor
        onPressed: cursorShape = Qt.ClosedHandCursor
        onReleased: {
            cursorShape = Qt.OpenHandCursor
            Snap.snap(root)
            IO.savePos(id, root)
        }
        onClicked: {
            selected = true
            imageFrame.forceActiveFocus()
            enabled = false
        }
    }

    Pane {
        id: imageFrame
        z: 0
        anchors.fill: parent
        background: Rectangle {
            color: backgroundColor
            border.width: borderWidth
            border.color: borderColor
            radius: cornerRadius
        }
        Image {
            id: img
            width: parent.width - 10
            height: parent.height - 10
            anchors.centerIn: parent
            source: IconSet.image
        }
    }

    CardEditBar {
        id: editBar
        borderColor: borderColor
    }

    CardPalette {
        id: palette
        borderColor: borderColor
    }
}
