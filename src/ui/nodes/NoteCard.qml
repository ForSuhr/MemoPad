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

ResizableItem {
    id: root
    width: Globals.dotInterval * 8
    height: Globals.dotInterval * 4

    property string cardID
    property string backgroundColor: "snow"
    property string borderColor: "gainsboro"
    property int borderWidth: 2
    property int cornerRadius: 10
    property alias text: rawTextArea.text

    property bool created: false
    property bool loaded: false
    property alias selected: rawTextArea.focus

    onCreatedChanged: {
        cardID = CardManager.createCard("note")
        Snap.snap(root)
        IO.saveTransform(cardID, root, false)
        IO.saveCardBackgroundColor(cardID, root, false)
    }
    onLoadedChanged: {
        rawTextArea.text = CardManager.text(cardID)
        root.width = CardManager.width(cardID)
        root.height = CardManager.height(cardID)
        root.backgroundColor = CardManager.backgroundColor(cardID)
        Snap.snap(root)
    }
    onSelectedChanged: {
        isVisble = selected
        mouseArea.enabled = !selected
        scrollView.z = selected ? 1 : 0
        editBar.visible = selected
        palette.visible = selected
        if (!selected)
            mouseArea.cursorShape = Qt.OpenHandCursor
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
            rawTextArea.forceActiveFocus()
            enabled = false
        }
    }

    ScrollView {
        id: scrollView
        z: 0
        width: parent.width
        height: parent.height
        anchors.fill: parent
        TextArea {
            id: rawTextArea
            leftPadding: 10
            rightPadding: 10
            background: Rectangle {
                color: backgroundColor
                border.width: borderWidth
                border.color: borderColor
                radius: cornerRadius
            }
            wrapMode: TextArea.Wrap
            textFormat: Text.PlainText
            font.pixelSize: 24
            color: "black"
            visible: false
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

            onFocusChanged: {
                if (focus) {
                    rawTextArea.visible = true
                    markdownTextArea.visible = false
                } else {
                    rawTextArea.visible = false
                    markdownTextArea.visible = true
                }
            }
            onEditingFinished: {
                IO.saveText(cardID, root)
                rawTextArea.focus = false
            }
        }
        TextArea {
            id: markdownTextArea
            anchors.fill: rawTextArea
            wrapMode: TextArea.Wrap
            leftPadding: 10
            rightPadding: 10
            text: rawTextArea.text
            textFormat: Text.MarkdownText
            font.pixelSize: 24
            readOnly: true
            color: "black"
            activeFocusOnPress: false
            activeFocusOnTab: false
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

    DropShadow {
        anchors.fill: scrollView
        source: scrollView
        radius: 6
        color: "gainsboro"
        smooth: true
    }

    ArrowDropArea {
        anchors.fill: root
    }
}
