import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import MemoPad.CardManager
import MemoPad.CommandManager
import MemoPad.PreferencesManager
import "js/IO.js" as IO

Item {
    id: root
    x: Globals.camera.x
    y: Globals.camera.y

    property alias nodeLayer: nodeLayer
    property alias edgeLayer: edgeLayer

    property real dotSize: Globals.dotSize
    property int dotInterval: Globals.dotInterval
    property string dotColor: "gainsboro"
    property bool hasBorder: true // indicate if the canvas has border
    property string borderColor: "gainsboro"
    property real zoomFactor: Globals.camera.zoomFactor
    property real zoomMin: 0.5 // zoom out
    property real zoomMax: 2.0 // zoom in

    function saveCamera() {
        PreferencesManager.camera = {
            "x": root.x,
            "y": root.y,
            "zoomFactor": zoomFactor
        }
    }

    transform: [
        Scale {
            id: itemScale
            origin.x: root.width / 2
            origin.y: root.height / 2
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

    DropShadow {
        anchors.fill: canvas
        source: canvas
        radius: 6
        color: "gainsboro"
        smooth: true
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
                       saveCamera()
                   }
        onWheel: wheel => {
                     // zoom in & out
                     var scrollAngleDelta = wheel.angleDelta.y / 120 // 120 units equals 15 degrees

                     var newZoomFactor = Math.min(
                         zoomMax,
                         Math.max(zoomMin,
                                  root.zoomFactor + 0.1 * scrollAngleDelta))
                     if (newZoomFactor !== root.zoomFactor) {
                         root.zoomFactor = newZoomFactor.toFixed(1)
                         saveCamera()
                     }
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
        onReleased: {
            cursorShape = Qt.ArrowCursor
            saveCamera()
        }
    }

    /*lose focus*/
    // once you click on this mouse area(it means that you clicked on somewhere outside any cards),
    // the cards will lose their focus, and they should be marked as unselected
    MouseArea {
        id: loseFocus
        z: 1
        anchors.fill: canvas
        onClicked: nodeLayer.forceActiveFocus()
    }

    /*NodeLayer is a container item where all node-cards are placed in it*/
    NodeLayer {
        id: nodeLayer
        z: 3
        onLoadCanvasSignal: canvasID => {
                                IO.loadCanvas(canvasID)
                            }
    }

    /*EdgeLayer is a container item where all edge-cards are placed in it*/
    EdgeLayer {
        id: edgeLayer
        z: 4
    }

    /*command undo&redo*/
    Connections {
        target: CommandManager
        function onMoveCardSignal(cardID, x, y) {
            for (var i = 0; i < nodeLayer.children.length; i++) {
                if (nodeLayer.children[i].cardID === cardID) {
                    nodeLayer.children[i].x = x
                    nodeLayer.children[i].y = y
                    IO.savePos(cardID, nodeLayer.children[i], false)
                }
            }
            for (var j = 0; j < edgeLayer.children.length; j++) {
                if (edgeLayer.children[j].cardID === cardID) {
                    edgeLayer.children[j].x = x
                    edgeLayer.children[j].y = y
                    IO.savePos(cardID, edgeLayer.children[j], false)
                }
            }
        }
        function onResizeCardSignal(cardID, width, height) {
            for (var i = 0; i < nodeLayer.children.length; i++) {
                if (nodeLayer.children[i].cardID === cardID) {
                    nodeLayer.children[i].width = width
                    nodeLayer.children[i].height = height
                    IO.saveSize(cardID, nodeLayer.children[i], false)
                }
            }
        }
        function onTransformCardSignal(cardID, x, y, width, height) {
            for (var i = 0; i < nodeLayer.children.length; i++) {
                if (nodeLayer.children[i].cardID === cardID) {
                    nodeLayer.children[i].x = x
                    nodeLayer.children[i].y = y
                    nodeLayer.children[i].width = width
                    nodeLayer.children[i].height = height
                    IO.saveTransform(cardID, nodeLayer.children[i], false)
                }
            }
        }
        function onChangeTextSignal(cardID, text) {
            for (var i = 0; i < nodeLayer.children.length; i++) {
                if (nodeLayer.children[i].cardID === cardID) {
                    nodeLayer.children[i].text = text
                    IO.saveText(cardID, nodeLayer.children[i], false)
                }
            }
        }
        function onChangeBackgroundColorSignal(cardID, color) {
            for (var i = 0; i < nodeLayer.children.length; i++) {
                if (nodeLayer.children[i].cardID === cardID) {
                    nodeLayer.children[i].backgroundColor = color
                    IO.saveCardBackgroundColor(cardID,
                                               nodeLayer.children[i], false)
                }
            }
        }
        function onChangeFromCardSignal(cardID, fromCardID, fromDirection, fromX, fromY) {
            for (var i = 0; i < edgeLayer.children.length; i++) {
                if (edgeLayer.children[i].cardID === cardID) {
                    edgeLayer.children[i].fromCardID = fromCardID
                    edgeLayer.children[i].fromCard = IO.getNodeById(fromCardID)
                    edgeLayer.children[i].fromDirection = fromDirection
                    edgeLayer.children[i].arrowFromX = fromX
                    edgeLayer.children[i].arrowFromY = fromY
                    edgeLayer.children[i].updateStartCirclePos()
                    IO.saveFromCard(cardID, edgeLayer.children[i], false)
                }
            }
        }
        function onChangeToCardSignal(cardID, toCardID, toDirection, toX, toY) {
            for (var i = 0; i < edgeLayer.children.length; i++) {
                if (edgeLayer.children[i].cardID === cardID) {
                    edgeLayer.children[i].toCardID = toCardID
                    edgeLayer.children[i].toCard = IO.getNodeById(toCardID)
                    edgeLayer.children[i].toDirection = toDirection
                    edgeLayer.children[i].arrowToX = toX
                    edgeLayer.children[i].arrowToY = toY
                    edgeLayer.children[i].updateArrowHeadPos()
                    IO.saveToCard(cardID, edgeLayer.children[i], false)
                }
            }
        }
        function onChangeArrowPosSignal(cardID, fromX, fromY, toX, toY, controlX, controlY) {
            for (var i = 0; i < edgeLayer.children.length; i++) {
                if (edgeLayer.children[i].cardID === cardID) {
                    edgeLayer.children[i].toCard = undefined
                    edgeLayer.children[i].arrowFromX = fromX
                    edgeLayer.children[i].arrowFromY = fromY
                    edgeLayer.children[i].arrowToX = toX
                    edgeLayer.children[i].arrowToY = toY
                    edgeLayer.children[i].arrowControlX = controlX
                    edgeLayer.children[i].arrowControlY = controlY
                    IO.saveArrowPos(cardID, edgeLayer.children[i], false)
                }
            }
        }
    }
}
