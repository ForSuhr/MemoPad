import QtQuick
import QtQuick.Controls
import MemoPad.CardManager
import MemoPad.CommandManager
import "Snap.js" as Snap
import "IO.js" as IO

ResizableItem {
    id: root
    width: Globals.dotInterval * 6
    height: Globals.dotInterval * 3

    property string id
    property string backgroundColor: "snow"
    property string borderColor: "gainsboro"
    property int borderWidth: 4
    property int cornerRadius: 10
    property alias text: textArea.text

    property bool created: false
    property bool loaded: false
    property bool selected: false

    onCreatedChanged: {
        id = CardManager.createCard("note")
        Snap.snap(root)
        IO.saveTransform(id, root, false)
        IO.saveBackgroundColor(id, root, false)
    }
    onLoadedChanged: {
        textArea.text = CardManager.text(id)
        root.width = CardManager.width(id)
        root.height = CardManager.height(id)
        root.backgroundColor = CardManager.backgroundColor(id)
        Snap.snap(root)
    }
    onSelectedChanged: {
        isVisble = selected
        textArea.focus = selected
        mouseArea.enabled = !selected
        editBar.visible = selected
        palette.visible = selected
        if (!selected) {
            mouseArea.cursorShape = Qt.OpenHandCursor
        }
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
            textArea.focus = true
            enabled = false
            cursorShape = Qt.IBeamCursor
        }
    }

    TextArea {
        id: textArea
        z: 0
        width: root.width
        height: root.height
        anchors.centerIn: parent
        topPadding: 15
        bottomPadding: 15
        leftPadding: 20
        rightPadding: 20
        background: Rectangle {
            color: backgroundColor
            border.width: borderWidth
            border.color: borderColor
            radius: cornerRadius
        }
        wrapMode: TextArea.Wrap
        textFormat: TextArea.MarkdownText
        font.pixelSize: 24
        color: "black"
        selectByMouse: true
        selectionColor: "darkseagreen"
        selectedTextColor: "black"
        activeFocusOnPress: false
        activeFocusOnTab: false

        // adjust text area according to contents automatically
        onContentHeightChanged: {
            if (Globals.cardSizeAutoAdjust) {
                root.height = (Math.floor(
                                   (contentHeight + topPadding + bottomPadding)
                                   / Globals.dotInterval) + 1) * Globals.dotInterval
            }
        }

        onEditingFinished: IO.saveText(id, root)
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
