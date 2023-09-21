import QtQuick
import QtQuick.Controls

Item {
    id: root
    width: 1000
    height: 500
    x: -parent.width / 2
    y: -parent.height / 2

    property int dotSize: 1
    property int dotInterval: 20
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
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, canvas.width, canvas.height)
            ctx.fillStyle = "gainsboro"
            for (var x = 0; x < canvas.width; x += dotInterval) {
                for (var y = 0; y < canvas.height; y += dotInterval) {
                    ctx.beginPath()
                    ctx.arc(x, y, dotSize, 0, 2 * Math.PI) // Draw a dot
                    ctx.fill()
                }
            }
        }
    }

    /*pan*/
    MouseArea {
        id: panArea
        anchors.fill: canvas
        drag.target: root // drag the whole item instead of canvas
        // TODO: add boundaries
        acceptedButtons: Qt.RightButton
    }

    /*scale*/
    MouseArea {
        id: scaleArea
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
                     root.zoomFactor += 0.1 * scrollAngleDelta
                     root.zoomFactor = Math.min(zoomMax,
                                                Math.max(zoomMin,
                                                         root.zoomFactor))
                 }
    }
}
