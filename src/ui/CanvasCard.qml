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
    property string canvasName: "canvas 0"

    property bool created: false
    property bool loaded: false
    property alias selected: teleport.focus

    onCreatedChanged: {
        id = CardManager.createCard("canvas")
        Snap.snap(root)
        IO.saveTransform(id, root, false)
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

    Pane {
        id: teleport
        anchors.fill: parent
        background: Rectangle {
            color: "snow"
            border.width: 4
            border.color: "gainsboro"
            radius: 10
        }
        MouseArea {
            anchors.fill: parent
            onDoubleClicked: console.log("create new canvas")
        }
    }

    TextField {
        id: nameTextField
        height: 30
        width: contentWidth + 20
        anchors.top: teleport.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        background: Rectangle {
            color: "snow"
            border.width: 4
            border.color: "gainsboro"
            radius: 10
        }
        text: canvasName
        font.pixelSize: 16
        horizontalAlignment: TextInput.AlignHCenter
        color: "black"
        selectByMouse: true
        selectionColor: "darkseagreen"
        selectedTextColor: "black"
    }

    CardEditBar {
        id: editBar
        borderColor: "gainsboro"
    }
}
