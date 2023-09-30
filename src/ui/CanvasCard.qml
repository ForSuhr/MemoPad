import QtQuick
import QtQuick.Controls
import MemoPad.CardManager
import MemoPad.CommandManager
import "Snap.js" as Snap
import "IO.js" as IO

ResizableItem {
    id: root
    width: Globals.dotInterval * 3
    height: Globals.dotInterval * 3

    property string id

    property bool created: false
    property bool loaded: false
    property bool selected: false

    onCreatedChanged: {
        id = CardManager.createCard("canvas")
        Snap.snap(root)
        IO.savePos(id, root)
        IO.saveSize(id, root)
    }
    onLoadedChanged: {
        root.width = CardManager.width(id)
        root.height = CardManager.height(id)
        Snap.snap(root)
    }
    onSelectedChanged: {
        isVisble = selected
        mouseArea.enabled = !selected
        editBar.visible = selected
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
        onPressed: cursorShape = Qt.ClosedHandCursor
        onReleased: {
            cursorShape = Qt.ArrowCursor
            Snap.snap(root)
            IO.savePos(id, root)
        }
        onClicked: {
            selected = true
            enabled = false
        }
    }

    Image {
        anchors.fill: parent
        source: "assets/themes/lumos/canvas.svg"
        mipmap: true
    }

    CardEditBar {
        id: editBar
        borderColor: "gainsboro"
    }
}
