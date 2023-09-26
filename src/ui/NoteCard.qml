import QtQuick
import QtQuick.Controls
import MemoPad.CardManager
import "Snap.js" as Snap
import "IO.js" as IO

ResizableItem {
    id: root
    width: Globals.dotInterval * 6
    height: Globals.dotInterval * 3

    property int cardIndex
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
        cardIndex = cardManager.createCard("note")
        Snap.snap(root)
        IO.savePos(cardIndex, root)
        IO.saveSize(cardIndex, root)
        IO.saveColor(cardIndex, root)
    }
    onLoadedChanged: {
        console.log("note card loaded")
        root.width = cardManager.width(cardIndex)
        root.height = cardManager.height(cardIndex)
        textArea.text = cardManager.text(cardIndex)
        root.cardBackgroundColor = cardManager.backgroundColor(cardIndex)
        Snap.snap(root)
    }
    onSelectedChanged: {
        isVisble = selected
        textArea.focus = selected
        mouseArea.enabled = !selected
        palette.visible = selected
        if (!selected)
            IO.saveText(cardIndex, textArea)
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
            IO.savePos(cardIndex, root)
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
        selectionColor: "aliceblue"
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

    CardPalette {
        id: palette
        borderColor: cardBorderColor
    }

    onCardBackgroundColorChanged: IO.saveColor(cardIndex, root)
}
