import QtQuick
import QtQuick.Shapes

Item {
    Rectangle {
        id: rect1
        x: 100
        y: 100
        width: 50
        height: 50
        color: "blue"
    }

    Rectangle {
        id: rect2
        x: 200
        y: 200
        width: 50
        height: 50
        color: "red"
    }

    property int triangleHigh: 12
    property int triangleTheta: 30
    property string arrowColor: "gray"
    property int arrowWidth: 4

    Shape {
        antialiasing: true
        smooth: true

        ShapePath {
            id: arcShapePath
            strokeColor: arrowColor
            strokeWidth: arrowWidth
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap

            startX: rect1.x + rect1.width / 2
            startY: rect1.y + rect1.height / 2

            PathArc {
                id: arc
                x: rect2.x + rect2.width / 2
                y: rect2.y + rect2.height / 2
                radiusX: 100
                radiusY: 100
                useLargeArc: false
            }
        }
        ShapePath {
            id: downwardTriangle
            strokeColor: arrowColor
            strokeWidth: 1
            fillColor: arrowColor
            capStyle: ShapePath.RoundCap

            startX: arc.x
            startY: arc.y

            PathLine {
                x: arc.x + triangleHigh * Math.tan(
                       Math.PI * triangleTheta / 180)
                y: arc.y
            }

            PathLine {
                id: endPoint
                x: arc.x
                y: arc.y + triangleHigh
            }

            PathLine {
                x: arc.x - triangleHigh * Math.tan(
                       Math.PI * triangleTheta / 180)
                y: arc.y
            }

            PathLine {
                x: arc.x
                y: arc.y
            }
        }
    }
}
