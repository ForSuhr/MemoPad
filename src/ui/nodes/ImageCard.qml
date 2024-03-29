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
    width: Globals.dotInterval * 8
    height: Globals.dotInterval * 8

    property string cardID
    property string backgroundColor: "snow"
    property string borderColor: "gainsboro"
    property int borderWidth: 2
    property int cornerRadius: 10
    property alias imageSource: img.source

    property bool created: false
    property bool loaded: false
    property alias selected: imageFrame.focus

    onCreatedChanged: {
        cardID = CardManager.createCard("image")
        Snap.snap(root)
        IO.saveTransform(cardID, root, false)
        IO.saveCardBackgroundColor(cardID, root, false)
    }
    onLoadedChanged: {
        root.width = CardManager.width(cardID)
        root.height = CardManager.height(cardID)
        root.backgroundColor = CardManager.backgroundColor(cardID)
        root.imageSource = CardManager.image(cardID)
        Snap.snap(root)
    }
    onSelectedChanged: {
        isVisble = selected
        mouseArea.enabled = !selected
        editBar.visible = selected
        palette.visible = selected
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
            fillMode: Image.PreserveAspectCrop
            mipmap: true
        }
        Canvas {
            id: roundedCorner
            anchors.fill: img
            layer.mipmap: true
            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                ctx.fillStyle = backgroundColor
                ctx.beginPath()
                ctx.rect(0, 0, width,
                         height) // draw a rect as "destination image"
                ctx.fill()

                ctx.beginPath()
                ctx.fillStyle = "transparent"
                ctx.roundedRect(
                            0, 0, width, height, cornerRadius,
                            cornerRadius) // draw a rounded rect as "source image"
                ctx.globalCompositeOperation = 'source-out' // display the "source image" wherever the source image is opaque and the destination image is transparent
                ctx.fill()
            }
        }
        Connections {
            target: root
            function onBackgroundColorChanged() {
                roundedCorner.requestPaint()
            }
        }
    }

    ImageCardEditBar {
        id: editBar
        borderColor: borderColor
        itemNum: 2
    }

    CardPalette {
        id: palette
        borderColor: borderColor
    }

    DropShadow {
        anchors.fill: imageFrame
        source: imageFrame
        radius: 6
        color: "gainsboro"
        smooth: true
    }

    ArrowDropArea {
        anchors.fill: root
    }
}
