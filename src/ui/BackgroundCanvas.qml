import QtQuick
import QtQuick.Controls

Item {
    id: root
    width: 1000
    height: 500

    property int dotSize: 1
    property int dotInterval: 20
    property real zoomFactor: 1.0
    property real zoomMin: 0.5 // zoom out
    property real zoomMax: 2.0 // zoom in

    transform: [
        Scale {
            id: itemScale
            origin.x: width / 2
            origin.y: height / 2
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

        //        Rectangle {
        //            width: 100
        //            height: 100
        //            color: "red"
        //            anchors.left: canvas.left
        //            anchors.top: canvas.top
        //        }
        //        Rectangle {
        //            width: 100
        //            height: 100
        //            color: "blue"
        //            anchors.right: canvas.right
        //            anchors.bottom: canvas.bottom
        //        }
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

        onPressed: mouse => {
                       root.zoomFactor = 1.0 // reset scale
                       canvas.x = 0
                       canvas.y = 0
                   }
        onWheel: wheel => {
                     var scrollAngleDelta = wheel.angleDelta.y / 120 // 120 units equals 15 degrees
                     root.zoomFactor += 0.1 * scrollAngleDelta
                     root.zoomFactor = Math.min(zoomMax,
                                                Math.max(zoomMin,
                                                         root.zoomFactor))
                 }
    }
}
