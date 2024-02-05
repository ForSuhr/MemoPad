import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import Qt5Compat.GraphicalEffects
import MemoPad.CardManager
import MemoPad.CommandManager
import "../js/Snap.js" as Snap
import "../js/IO.js" as IO
import "decos"
import MemoPad.Globals
import MemoPad.IconSet

ResizableItem {
    id: root
    width: Globals.dotInterval * 4
    height: Globals.dotInterval * 4

    // card id, this is referring to the card itself
    property string cardID
    // canvas id, this is referring to the target canvas
    property string canvasID
    property string canvasName: "new canvas"
    property string upperCanvasID

    property string backgroundColor: "snow"
    property string borderColor: "gainsboro"
    property int borderWidth: 2
    property int cornerRadius: 10

    property string newCanvasColor: "floralwhite"

    property bool created: false
    property bool loaded: false
    property alias selected: teleport.focus

    onCreatedChanged: {
        cardID = CardManager.createCard("canvas")
        canvasID = CardManager.createCanvas(cardID, canvasName)
        Snap.snap(root)
        IO.saveTransform(cardID, root, false)
        IO.saveCanvasID(cardID, root, false)
        IO.saveCanvasName(cardID, root, false)
        IO.saveCardBackgroundColor(cardID, root, false)
        IO.saveCanvasColor(canvasID, newCanvasColor)
    }
    onLoadedChanged: {
        root.width = CardManager.width(cardID)
        root.height = CardManager.height(cardID)
        root.backgroundColor = CardManager.backgroundColor(cardID)
        canvasID = CardManager.canvasID(cardID)
        canvasName = CardManager.canvasName(cardID)
        Snap.snap(root)
    }
    onSelectedChanged: {
        isVisble = selected
        palette.visible = selected
        mouseArea.enabled = !selected
        editBar.visible = selected
        root.parent.setCardToTop(cardID)
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
            IO.savePos(cardID, root)
        }
        onClicked: {
            selected = true
            enabled = false
        }
    }

    Image {
        id: door
        z: 2
        width: root.width - Globals.dotInterval * 2
        height: root.height - Globals.dotInterval * 2
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
            border.width: borderWidth
            border.color: borderColor
            radius: cornerRadius
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
        font.family: Globals.fontName
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
            IO.saveCanvasName(cardID, root)
            nameTextField.focus = false
        }
        onActiveFocusChanged: if (focus)
                                  nameTextField.selectAll()
    }

    CardEditBar {
        id: editBar
        borderColor: borderColor
        itemNum: 1
    }

    CardPalette {
        id: palette
        borderColor: borderColor
        anchors.top: nameTextField.bottom
    }

    DropShadow {
        anchors.fill: teleport
        source: teleport
        radius: 6
        color: "gainsboro"
        smooth: true
    }

    DropShadow {
        anchors.fill: nameTextField
        source: nameTextField
        radius: 4
        color: "gainsboro"
        smooth: true
    }

    ArrowDropArea {
        anchors.fill: root
    }
}
