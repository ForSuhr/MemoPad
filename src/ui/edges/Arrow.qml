import QtQuick
import QtQuick.Shapes

Item {
    property string fromCardID: ""
    property string toCardID: ""
    property string fromDirection: ""
    property string toDirection: ""
    property alias toCardX: card.x
    property alias toCardY: card.y

    onToCardXChanged: {
        if (toCardID !== "") {
            arrowhead.x = toCardX
            arrowhead.y = toCardY
        }
    }

    onToCardYChanged: {
        if (toCardID !== "") {
            arrowhead.x = toCardX
            arrowhead.y = toCardY
        }
    }

    property alias arrowFromX: startCircle.x
    property alias arrowFromY: startCircle.y
    property alias arrowToX: arrowhead.x
    property alias arrowToY: arrowhead.y

    property real arcFromX: 100
    property real arcFromY: 100
    property real arcToX: 500
    property real arcToY: 100
    property real midwayX: arcFromX + (arcToX - arcFromX) / 2
    property real midwayY: arcFromY + (arcToY - arcFromY) / 2
    property real dynamicMidwayX: startCircle.x + (arrowhead.x - startCircle.x) / 2
    property real dynamicMidwayY: startCircle.y + (arrowhead.y - startCircle.y) / 2
    property real tolerance: 20 // when you drag the control circle, it will snap to the midway point when it comes into an area of this tolerance

    property int triangleHigh: 12
    property int triangleTheta: 30
    property string circleColor: "black"
    property string arrowColor: "darkgray"
    property string arrowHeadColor: "black"
    property int arrowWidth: 4
    property int arcRadiusX: 100
    property int arcRadiusY: 100
    property int east: 0
    property int southeast: 45
    property int south: 90
    property int southwest: 135
    property int west: 180
    property int northwest: 225
    property int north: 270
    property int northeast: 315
    property alias arrowHeadDirection: rotation.angle

    Component.onCompleted: arrowHeadDirection = east

    Shape {
        id: arrow
        width: Math.abs(arcToX - arcFromX)
        height: Math.abs(arcToY - arcFromY)
        antialiasing: true
        smooth: true

        Item {
            id: startCircle
            x: arcFromX
            y: arcFromY
            width: triangleHigh
            height: triangleHigh
            Rectangle {
                x: -parent.width / 2
                y: -parent.height / 2
                width: parent.width
                height: parent.height
                color: circleColor
                radius: width / 2
                MouseArea {
                    scale: 2
                    anchors.fill: parent
                    drag.target: startCircle
                    hoverEnabled: true
                    onEntered: cursorShape = Qt.OpenHandCursor
                }
            }
        }

        Item {
            id: controlCircle
            x: midwayX
            y: midwayY
            width: triangleHigh
            height: triangleHigh
            Rectangle {
                x: -parent.width / 2
                y: -parent.height / 2
                width: parent.width
                height: parent.height
                color: circleColor
                radius: width / 2
                MouseArea {
                    anchors.fill: parent
                    drag.target: controlCircle
                    hoverEnabled: true
                    onEntered: cursorShape = Qt.OpenHandCursor
                }
            }
            onXChanged: {
                if (Math.abs(dynamicMidwayX - controlCircle.x) <= tolerance & Math.abs(
                            dynamicMidwayY - controlCircle.y) <= tolerance) {
                    x = dynamicMidwayX
                    y = dynamicMidwayY
                }
                updateArrowHeadDirection()
            }
            onYChanged: {
                if (Math.abs(dynamicMidwayX - controlCircle.x) <= tolerance & Math.abs(
                            dynamicMidwayY - controlCircle.y) <= tolerance) {
                    x = dynamicMidwayX
                    y = dynamicMidwayY
                }
                updateArrowHeadDirection()
            }
        }

        ShapePath {
            id: arcShapePath
            strokeColor: arrowColor
            strokeWidth: arrowWidth
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap

            startX: startCircle.x
            startY: startCircle.y
            pathElements: [
                PathQuad {
                    id: arc
                    x: arrowhead.x
                    y: arrowhead.y
                    controlX: controlCircle.x
                    controlY: controlCircle.y
                }
            ]
        }

        Shape {
            id: arrowhead
            antialiasing: true
            smooth: true
            x: arcToX
            y: arcToY
            width: triangleHigh * 1.2
            height: triangleHigh * 1.2

            Drag.keys: ["arrowhead"]
            Drag.hotSpot.x: width / 2
            Drag.hotSpot.y: height / 2
            Drag.active: arrowheadMouseArea.drag.active

            ShapePath {
                id: triangleShapePath
                strokeColor: arrowHeadColor
                strokeWidth: 1
                fillColor: arrowHeadColor
                capStyle: ShapePath.RoundCap

                startX: 0
                startY: 0
                pathElements: [
                    PathLine {
                        x: triangleShapePath.startX
                        y: triangleShapePath.startY + triangleHigh * Math.tan(
                               Math.PI * triangleTheta / 180)
                    },
                    PathLine {
                        id: endPoint
                        x: triangleShapePath.startX + triangleHigh
                        y: triangleShapePath.startY
                    },
                    PathLine {
                        x: triangleShapePath.startX
                        y: triangleShapePath.startY - triangleHigh * Math.tan(
                               Math.PI * triangleTheta / 180)
                    },
                    PathLine {
                        x: triangleShapePath.startX
                        y: triangleShapePath.startY
                    }
                ]
            }
            transform: Rotation {
                id: rotation
                origin.x: triangleShapePath.startX
                origin.y: triangleShapePath.startY
                angle: 0
                axis.z: 1
            }

            MouseArea {
                id: arrowheadMouseArea
                scale: 2
                anchors.fill: arrowhead
                drag.target: arrowhead
                hoverEnabled: true
                property real initialX
                property real initialY
                property bool isDragging: false
                onEntered: cursorShape = Qt.OpenHandCursor
                onPressed: mouse => {
                               initialX = mouse.x
                               initialY = mouse.y
                               isDragging = true
                           }
                onPositionChanged: mouse => {
                                       if (isDragging) {
                                           var distance = Math.sqrt(
                                               Math.pow(mouse.x - initialX,
                                                        2) + Math.pow(
                                                   mouse.y - initialY, 2))
                                           if (distance > 5) {
                                               toCardID = ""
                                           }
                                       }
                                   }
                onReleased: {
                    isDragging = false
                    arrowhead.Drag.drop()
                }
            }

            onXChanged: updateArrowHeadDirection()
            onYChanged: updateArrowHeadDirection()
        }
    }
    function updateArrowHeadDirection() {
        arrowHeadDirection = Math.atan2(
                    (arrowhead.y - controlCircle.y),
                    (arrowhead.x - controlCircle.x)) * 180 / Math.PI
    }
}
