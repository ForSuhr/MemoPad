import QtQuick
import QtQuick.Controls
import MemoPad.CardManager
import MemoPad.CommandManager
import "Snap.js" as Snap
import "IO.js" as IO

ResizableItem {
    id: root
    width: Globals.dotInterval * 4
    height: Globals.dotInterval * 4

    // card id, this is referring to the card itself
    property string id
    // canvas id, this is referring to the target canvas
    property string canvasID
    property string canvasName: "new canvas"
    property string upperCanvasID

    property string backgroundColor: "snow"
    property string borderColor: "gainsboro"
    property int borderWidth: 2
    property int cornerRadius: 10

    property bool created: false
    property bool loaded: false
    property alias selected: teleport.focus

    onCreatedChanged: {
        id = CardManager.createCard("canvas")
        canvasID = CardManager.createCanvas(id, canvasName)
        Snap.snap(root)
        IO.saveTransform(id, root, false)
        IO.saveCanvasID(id, root)
        IO.saveCanvasName(id, root)
    }
    onLoadedChanged: {
        root.width = CardManager.width(id)
        root.height = CardManager.height(id)
        root.backgroundColor = CardManager.backgroundColor(id)
        canvasID = CardManager.canvasID(id)
        canvasName = CardManager.canvasName(id)
        Snap.snap(root)
    }
    onSelectedChanged: {
        isVisble = selected
        palette.visible = selected
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
            enabled = false
        }
    }

    Image {
        id: door
        z: 2
        width: root.width - Globals.dotInterval * 1
        height: root.height - Globals.dotInterval * 1
        fillMode: Qt.KeepAspectRatio
        mipmap: true
        anchors.centerIn: teleport
        source: IconSet.doorClosed
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                door.source = IconSet.doorOpen
                cursorShape = Qt.PointingHandCursor
            }
            onExited: {
                door.source = IconSet.doorClosed
                cursorShape = Qt.OpenHandCursor
            }
            onClicked: {
                root.parent.loadCanvasSignal(canvasID)
            }
        }
    }

    Pane {
        id: teleport
        anchors.fill: parent
        background: Rectangle {
            color: backgroundColor
            border.width: 2
            border.color: "gainsboro"
            radius: 10
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
            color: backgroundColor
            border.width: borderWidth
            border.color: borderColor
            radius: cornerRadius
        }
        text: canvasName
        font.pixelSize: 16
        horizontalAlignment: TextInput.AlignHCenter
        color: "black"
        selectByMouse: true
        selectionColor: "darkseagreen"
        selectedTextColor: "black"
        activeFocusOnPress: true
        activeFocusOnTab: false
        onEditingFinished: {
            canvasName = text
            IO.saveCanvasName(id, root)
            nameTextField.focus = false
        }
        onActiveFocusChanged: if (focus)
                                  nameTextField.selectAll()
    }

    CardEditBar {
        id: editBar
        borderColor: borderColor
    }

    CardPalette {
        id: palette
        borderColor: borderColor
        anchors.top: nameTextField.bottom
    }
}
