import QtQuick
import QtQuick.Shapes
import Qt5Compat.GraphicalEffects
import MemoPad.CardManager
import "../js/IO.js" as IO
import "decos"

Item {
    id: arrow
    containmentMask: arcArea

    property string cardID
    property bool created: false
    property bool loaded: false
    property bool selected: arrow.focus

    Component.onCompleted: {
        arrowHeadDirection = east
    }
    onCreatedChanged: {
        cardID = CardManager.createCard("arrow")
        IO.saveTransform(cardID, arrow, false)
    }
    onLoadedChanged: {

    }
    onSelectedChanged: {
        controlCircle.visible = selected
        editBar.visible = selected
        arcAreaPath.fillColor = selected ? "#22000000" : "transparent"
    }

    HoverHandler {
        id: hoverHandler
        cursorShape: Qt.OpenHandCursor
        onHoveredChanged: {
            if (!selected) {
                controlCircle.visible = hovered ? true : false
                arcAreaPath.fillColor = hovered ? "#22000000" : "transparent"
            }
        }
    }

    TapHandler {
        id: tapHandler
        onTapped: {
            arrow.forceActiveFocus()
        }
    }

    DragHandler {
        id: dragHandler
        target: arrow
    }

    property string fromCardID: ""
    property string toCardID: ""
    property string fromDirection: ""
    property string toDirection: ""

    property var fromCard: undefined
    property var toCard: undefined

    property real fromCardX: 0
    property real fromCardY: 0
    property real toCardX: toCard === undefined ? 0 : toCard.x
    property real toCardY: toCard === undefined ? 0 : toCard.y

    onToCardXChanged: {
        if (toCard !== undefined) {
            arrowhead.x = toCardX - x
            arrowhead.y = toCardY - y
        }
    }

    onToCardYChanged: {
        if (toCard !== undefined) {
            arrowhead.x = toCardX - x
            arrowhead.y = toCardY - y
        }
    }

    property alias arrowFromX: arrow.x
    property alias arrowFromY: arrow.y
    property alias arrowToX: arrowhead.x
    property alias arrowToY: arrowhead.y

    property real arcFromX: 0
    property real arcFromY: 0
    property real arcToX: 100
    property real arcToY: 0
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

    Item {
        id: startCircle
        x: arcFromX
        y: arcFromY
        z: 99
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
        z: 99
        width: triangleHigh
        height: triangleHigh
        visible: hoverHandler.hovered
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
                onEntered: {
                    cursorShape = Qt.OpenHandCursor
                    dragHandler.enabled = false
                }
                onExited: dragHandler.enabled = true
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

    Shape {
        id: arcShape
        antialiasing: true
        smooth: true

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
    }

    function isPointNearArc(mouseX, mouseY) {
        var numSamples = 10
        var distanceThreshold = 10
        for (var t = 0; t < 1; t += 1 / numSamples) {
            var posX = arcShapePath.pointAtPercent(t).x
            var posY = arcShapePath.pointAtPercent(t).y
            var distance = Math.sqrt(Math.pow(posX - mouseX,
                                              2) + Math.pow(posY - mouseY, 2))
            if (distance < distanceThreshold)
                return true
        }
        return false
    }

    property real radian1: Math.atan2(arrowhead.y - startCircle.y,
                                      arrowhead.x - startCircle.x)
    property real radian2: Math.atan2(arrowhead.y - controlCircle.y,
                                      arrowhead.x - controlCircle.x)
    property real radian3: Math.atan2(controlCircle.y - startCircle.y,
                                      controlCircle.x - startCircle.x)
    property real distance: Math.sqrt(Math.pow(arrowhead.x - startCircle.x,
                                               2) + Math.pow(
                                          arrowhead.y - startCircle.y, 2))
    Shape {
        id: arcArea
        antialiasing: true
        smooth: true
        containsMode: Shape.FillContains

        ShapePath {
            id: arcAreaPath
            strokeColor: "transparent"
            strokeWidth: 1
            fillColor: "transparent"
            startX: startCircle.x
            startY: startCircle.y

            // when the control point cross through the segment between startCircle and arrowhead
            // it is necessary to switch between different vertices
            pathElements: [
                PathLine {
                    x: radian3 - radian1 >= 0 ? startCircle.x + 10 / 2 * Math.sin(
                                                    radian1) : startCircle.x - 10 / 2 * Math.sin(
                                                    radian3)
                    y: radian3 - radian1 >= 0 ? startCircle.y - 10 / 2 * Math.cos(
                                                    radian1) : startCircle.y + 10 / 2 * Math.cos(
                                                    radian3)
                },
                PathLine {
                    x: radian3 - radian1 >= 0 ? arrowhead.x + 10 / 2 * Math.sin(
                                                    radian1) : arrowhead.x - 10 / 2 * Math.sin(
                                                    radian2)
                    y: radian3 - radian1 >= 0 ? arrowhead.y - 10 / 2 * Math.cos(
                                                    radian1) : arrowhead.y + 10 / 2 * Math.cos(
                                                    radian2)
                },
                PathLine {
                    x: radian3 - radian1 >= 0 ? arrowhead.x - 10 / 2 * Math.sin(
                                                    radian2) : arrowhead.x + 10 / 2 * Math.sin(
                                                    radian1)
                    y: radian3 - radian1 >= 0 ? arrowhead.y + 10 / 2 * Math.cos(
                                                    radian2) : arrowhead.y - 10 / 2 * Math.cos(
                                                    radian1)
                },
                PathLine {
                    x: radian3 - radian1 >= 0 ? controlCircle.x - 10 / 2 * Math.sin(
                                                    radian2) : controlCircle.x - 10 / 2 * Math.sin(
                                                    radian3)
                    y: radian3 - radian1 >= 0 ? controlCircle.y + 10 / 2 * Math.cos(
                                                    radian2) : controlCircle.y + 10 / 2 * Math.cos(
                                                    radian3)
                },
                PathLine {
                    x: radian3 - radian1 >= 0 ? controlCircle.x - 10 / 2 * Math.sin(
                                                    radian3) : controlCircle.x - 10 / 2 * Math.sin(
                                                    radian2)
                    y: radian3 - radian1 >= 0 ? controlCircle.y + 10 / 2 * Math.cos(
                                                    radian3) : controlCircle.y + 10 / 2 * Math.cos(
                                                    radian2)
                },
                PathLine {
                    x: radian3 - radian1 >= 0 ? startCircle.x - 10 / 2 * Math.sin(
                                                    radian3) : startCircle.x + 10 / 2 * Math.sin(
                                                    radian1)
                    y: radian3 - radian1 >= 0 ? startCircle.y + 10 / 2 * Math.cos(
                                                    radian3) : startCircle.y - 10 / 2 * Math.cos(
                                                    radian1)
                }
            ]
        }

        ShapePath {
            id: arcAreaTriangle
            strokeColor: "transparent"
            strokeWidth: 1
            fillColor: "transparent"
            //fillColor: hoverHandler.hovered ? "#22000000" : "transparent"
            startX: startCircle.x
            startY: startCircle.y
            pathElements: [
                PathLine {
                    x: controlCircle.x
                    y: controlCircle.y
                },
                PathLine {
                    x: arrowhead.x
                    y: arrowhead.y
                },
                PathLine {
                    x: startCircle.x
                    y: startCircle.y
                }
            ]
        }
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
        Drag.proposedAction: Qt.MoveAction
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
                                           toCard = undefined
                                       }
                                   }
                               }
            onReleased: {
                isDragging = false
                if (arrowhead.Drag.drop() === Qt.MoveAction)
                    toCard = IO.getCardById(toCardID)
            }
        }

        onXChanged: updateArrowHeadDirection()
        onYChanged: updateArrowHeadDirection()
    }
    function updateArrowHeadDirection() {
        arrowHeadDirection = Math.atan2(
                    (arrowhead.y - controlCircle.y),
                    (arrowhead.x - controlCircle.x)) * 180 / Math.PI
    }

    ArrowEditBar {
        id: editBar
        x: controlCircle.x - width / 2
        y: radian3 - radian1 >= 0 ? controlCircle.y + 20 : controlCircle.y - 20 - height
    }
}
