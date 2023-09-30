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
    property string cardBackgroundColor: "snow"
    property string cardBorderColor: "gainsboro"
    property int cardBorderWidth: 4
    property int cardRadius: 10

    property bool created: false
    property bool loaded: false
    property bool selected: false

    onCreatedChanged: {
        id = CardManager.createCard("note")
        Snap.snap(root)
        IO.saveTransform(id, root)
        IO.saveColor(id, root)
    }
    onLoadedChanged: {
        textArea.text = CardManager.text(id)
        root.width = CardManager.width(id)
        root.height = CardManager.height(id)
        root.cardBackgroundColor = CardManager.backgroundColor(id)
        Snap.snap(root)
    }
    onSelectedChanged: {
        isVisble = selected
        textArea.focus = selected
        mouseArea.enabled = !selected
        editBar.visible = selected
        palette.visible = selected
        if (!selected) {
            IO.saveText(id, textArea)
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
            color: cardBackgroundColor
            border.width: cardBorderWidth
            border.color: cardBorderColor
            radius: cardRadius
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
    }

    CardEditBar {
        id: editBar
        borderColor: cardBorderColor
    }

    CardPalette {
        id: palette
        borderColor: cardBorderColor
    }

    onCardBackgroundColorChanged: IO.saveColor(id, root)
}
