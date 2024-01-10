import QtQuick
import QtQuick.Controls
import MemoPad.CardManager
import MemoPad.CommandManager
import "js/IO.js" as IO

Item {
    id: root
    x: -parent.width / 2
    y: -parent.height / 2

    property alias cardLayer: cardLayer
    property real dotSize: Globals.dotSize
    property int dotInterval: Globals.dotInterval
    property string dotColor: "gainsboro"
    property bool hasBorder: true // indicate if the canvas has border
    property string borderColor: "gainsboro"
    property real zoomFactor: 1.0
    property real zoomMin: 0.5 // zoom out
    property real zoomMax: 2.0 // zoom in
    property real mouseX: 0.0
    property real mouseY: 0.0

    transform: [
        Scale {
            id: itemScale
            origin.x: root.mouseX
            origin.y: root.mouseY
            xScale: zoomFactor
            yScale: zoomFactor
        }
    ]

    Canvas {
        id: canvas
        z: 0
        width: root.width
        height: root.height
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.fillStyle = dotColor
            for (var x = dotInterval; x < canvas.width; x += dotInterval) {
                for (var y = dotInterval; y < canvas.height; y += dotInterval) {
                    ctx.beginPath()
                    ctx.arc(x, y, dotSize, 0, 2 * Math.PI) // Draw a dot
                    ctx.fill()
                }
            }

            // Draw a border (a rectangle around the Canvas)
            if (hasBorder) {
                ctx.strokeStyle = borderColor
                ctx.lineWidth = 10
                ctx.beginPath()
                ctx.rect(0, 0, width, height)
                ctx.closePath()
                ctx.stroke()
            }
        }
    }

    /*scale*/
    MouseArea {
        id: scaleArea
        z: 1
        anchors.fill: canvas
        acceptedButtons: Qt.MiddleButton

        onPressed: () => {
                       root.zoomFactor = 1.0 // reset scale
                       root.x = -root.parent.width / 2
                       root.y = -root.parent.height / 2
                   }
        onWheel: wheel => {
                     // get mouse position when wheel is scrolled
                     root.mouseX = wheel.x
                     root.mouseY = wheel.y
                     // zoom in & out
                     var scrollAngleDelta = wheel.angleDelta.y / 120 // 120 units equals 15 degrees
                     root.zoomFactor = Math.min(
                         zoomMax,
                         Math.max(zoomMin,
                                  root.zoomFactor + 0.1 * scrollAngleDelta))
                 }
    }

    /*pan*/
    MouseArea {
        id: panArea
        z: 2
        anchors.fill: canvas
        drag.target: root // drag the whole item instead of canvas
        acceptedButtons: Qt.RightButton
        onPressed: cursorShape = Qt.ClosedHandCursor
        onReleased: cursorShape = Qt.ArrowCursor
    }

    /*lose focus*/
    // once you click on this mouse area(it means that you clicked on somewhere outside any cards),
    // the cards will lose their focus, and they should be marked as unselected
    MouseArea {
        id: loseFocus
        z: 1
        anchors.fill: canvas
        onClicked: cardLayer.forceActiveFocus()
    }

    /*CardLayer is a container item where all cards are placed in it*/
    CardLayer {
        id: cardLayer
        z: 3
        onLoadCanvasSignal: canvasID => {
                                IO.loadCanvas(canvasID)
                            }
    }

    /*command undo&redo*/
    Connections {
        target: CommandManager
        function onMoveCardSignal(id, x, y) {
            for (var i = 0; i < cardLayer.children.length; i++) {
                if (cardLayer.children[i].id === id) {
                    cardLayer.children[i].x = x
                    cardLayer.children[i].y = y
                    IO.savePos(id, cardLayer.children[i], false)
                }
            }
        }
        function onResizeCardSignal(id, width, height) {
            for (var i = 0; i < cardLayer.children.length; i++) {
                if (cardLayer.children[i].id === id) {
                    cardLayer.children[i].width = width
                    cardLayer.children[i].height = height
                    IO.saveSize(id, cardLayer.children[i], false)
                }
            }
        }
        function onTransformCardSignal(id, x, y, width, height) {
            for (var i = 0; i < cardLayer.children.length; i++) {
                if (cardLayer.children[i].id === id) {
                    cardLayer.children[i].x = x
                    cardLayer.children[i].y = y
                    cardLayer.children[i].width = width
                    cardLayer.children[i].height = height
                    IO.saveTransform(id, cardLayer.children[i], false)
                }
            }
        }
        function onChangeTextSignal(id, text) {
            for (var i = 0; i < cardLayer.children.length; i++) {
                if (cardLayer.children[i].id === id) {
                    cardLayer.children[i].text = text
                    IO.saveText(id, cardLayer.children[i], false)
                }
            }
        }
        function onChangeBackgroundColorSignal(id, color) {
            for (var i = 0; i < cardLayer.children.length; i++) {
                if (cardLayer.children[i].id === id) {
                    cardLayer.children[i].backgroundColor = color
                    IO.saveBackgroundColor(id, cardLayer.children[i], false)
                }
            }
        }
    }
}
