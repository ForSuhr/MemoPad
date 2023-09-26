import QtQuick
import QtQuick.Controls
import MemoPad.CardManager
import "Snap.js" as Snap
import "IO.js" as IO

ResizableItem {
    id: root
    width: Globals.dotInterval * 6
    height: Globals.dotInterval * 3

    property string id
    property CardManager cardManager
    property string cardBackgroundColor: "snow"
    property string cardBorderColor: "gainsboro"
    property int cardBorderWidth: 4
    property int cardRadius: 10

    property bool created: false
    property bool loaded: false
    property bool selected: false

    onCreatedChanged: {
        console.log("note card created")
        id = cardManager.createCard("note")
        Snap.snap(root)
        IO.savePos(id, root)
        IO.saveSize(id, root)
        IO.saveColor(id, root)
    }
    onLoadedChanged: {
        console.log("note card loaded")
        textArea.text = cardManager.text(id)
        root.width = cardManager.width(id)
        root.height = cardManager.height(id)
        root.cardBackgroundColor = cardManager.backgroundColor(id)
        Snap.snap(root)
    }
    onSelectedChanged: {
        isVisble = selected
        textArea.focus = selected
        mouseArea.enabled = !selected
        editBar.visible = selected
        palette.visible = selected
        if (!selected)
            IO.saveText(id, textArea)
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
            textArea.focus = true
            enabled = false
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
            root.height = (Math.floor(
                               (contentHeight + topPadding + bottomPadding)
                               / Globals.dotInterval) + 1) * Globals.dotInterval
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
