import QtQuick
import QtQuick.Controls

Item {
    id: root
    width: 100
    height: 100

    property real zoomFactor: 1.0
    property real panX: 0
    property real panY: 0

    Canvas {
        id: canvas
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, canvas.width, canvas.height)
            ctx.fillStyle = "gainsboro"
            var dotSize = 1
            for (var x = 0; x < canvas.width; x += 20) {
                for (var y = 0; y < canvas.height; y += 20) {
                    ctx.beginPath()
                    ctx.arc(x, y, dotSize, 0, 2 * Math.PI) // Draw a dot
                    ctx.fill()
                }
            }
        }
        transform: [
            Scale {
                origin.x: canvas.width / 2
                origin.y: canvas.height / 2
                xScale: zoomFactor
                yScale: zoomFactor
            },
            Translate {
                x: root.panX
                y: root.panY
            }
        ]
    }

    Slider {
        id: zoomSlider
        from: 1.0
        to: 2.0
        value: 1.0 // initial zoom factor
        onValueChanged: {
            zoomFactor = value
        }
    }

    MouseArea {
        id: panArea
        anchors.fill: canvas
        drag.target: canvas
        acceptedButtons: Qt.RightButton
        property real lastMouseX: 0
        property real lastMouseY: 0

        onPressed: {
            lastMouseX = mouseX
            lastMouseY = mouseY
        }

        onPositionChanged: {
            if (drag.active) {
                var deltaX = (mouseX - lastMouseX) / root.zoomFactor
                var deltaY = (mouseY - lastMouseY) / root.zoomFactor
                root.panX += deltaX
                root.panY += deltaY
                lastMouseX = mouseX
                lastMouseY = mouseY
                canvas.requestPaint() // Redraw the canvas after pan
            }
        }
    }
}
