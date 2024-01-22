import QtQuick

Item {
    id: arrowDropArea

    property int areaRadius: 40
    property string hoverColor: "#22000000"

    Rectangle {
        id: northwest
        x: -width / 2
        y: -height / 2
        width: areaRadius
        height: width
        radius: width / 2
        color: "transparent"

        DropArea {
            anchors.fill: parent
            keys: ["arrowhead", "startCircle"]
            onPositionChanged: drag => {
                                   drag.source.x = -drag.source.parent.x + arrowDropArea.parent.x
                                   drag.source.y = -drag.source.parent.y + arrowDropArea.parent.y
                               }
            onEntered: parent.color = hoverColor
            onExited: parent.color = "transparent"
            onDropped: drop => {
                           parent.color = "transparent"
                           drop.acceptProposedAction()
                           drop.source.cardID = cardID
                           drop.source.direction = "northwest"
                       }
        }
    }

    Rectangle {
        id: north
        x: -width / 2 + arrowDropArea.parent.width / 2
        y: -height / 2
        width: areaRadius
        height: width
        radius: width / 2
        color: "transparent"

        DropArea {
            anchors.fill: parent
            keys: ["arrowhead", "startCircle"]
            onPositionChanged: drag => {
                                   drag.source.x = -drag.source.parent.x
                                   + arrowDropArea.parent.x + arrowDropArea.parent.width / 2
                                   drag.source.y = -drag.source.parent.y + arrowDropArea.parent.y
                               }
            onEntered: parent.color = hoverColor
            onExited: parent.color = "transparent"
            onDropped: drop => {
                           parent.color = "transparent"
                           drop.acceptProposedAction()
                           drop.source.cardID = cardID
                           drop.source.direction = "north"
                       }
        }
    }

    Rectangle {
        id: northeast
        x: -width / 2 + arrowDropArea.parent.width
        y: -height / 2
        width: areaRadius
        height: width
        radius: width / 2
        color: "transparent"

        DropArea {
            anchors.fill: parent
            keys: ["arrowhead", "startCircle"]
            onPositionChanged: drag => {
                                   drag.source.x = -drag.source.parent.x
                                   + arrowDropArea.parent.x + arrowDropArea.parent.width
                                   drag.source.y = -drag.source.parent.y + arrowDropArea.parent.y
                               }
            onEntered: parent.color = hoverColor
            onExited: parent.color = "transparent"
            onDropped: drop => {
                           parent.color = "transparent"
                           drop.acceptProposedAction()
                           drop.source.cardID = cardID
                           drop.source.direction = "northeast"
                       }
        }
    }

    Rectangle {
        id: east
        x: -width / 2 + arrowDropArea.parent.width
        y: -height / 2 + arrowDropArea.parent.height / 2
        width: areaRadius
        height: width
        radius: width / 2
        color: "transparent"

        DropArea {
            anchors.fill: parent
            keys: ["arrowhead", "startCircle"]
            onPositionChanged: drag => {
                                   drag.source.x = -drag.source.parent.x
                                   + arrowDropArea.parent.x + arrowDropArea.parent.width
                                   drag.source.y = -drag.source.parent.y
                                   + arrowDropArea.parent.y + arrowDropArea.parent.height / 2
                               }
            onEntered: parent.color = hoverColor
            onExited: parent.color = "transparent"
            onDropped: drop => {
                           parent.color = "transparent"
                           drop.acceptProposedAction()
                           drop.source.cardID = cardID
                           drop.source.direction = "east"
                       }
        }
    }

    Rectangle {
        id: southeast
        x: -width / 2 + arrowDropArea.parent.width
        y: -height / 2 + arrowDropArea.parent.height
        width: areaRadius
        height: width
        radius: width / 2
        color: "transparent"

        DropArea {
            anchors.fill: parent
            keys: ["arrowhead", "startCircle"]
            onPositionChanged: drag => {
                                   drag.source.x = -drag.source.parent.x
                                   + arrowDropArea.parent.x + arrowDropArea.parent.width
                                   drag.source.y = -drag.source.parent.y
                                   + arrowDropArea.parent.y + arrowDropArea.parent.height
                               }
            onEntered: parent.color = hoverColor
            onExited: parent.color = "transparent"
            onDropped: drop => {
                           parent.color = "transparent"
                           drop.acceptProposedAction()
                           drop.source.cardID = cardID
                           drop.source.direction = "southeast"
                       }
        }
    }

    Rectangle {
        id: south
        x: -width / 2 + arrowDropArea.parent.width / 2
        y: -height / 2 + arrowDropArea.parent.height
        width: areaRadius
        height: width
        radius: width / 2
        color: "transparent"

        DropArea {
            anchors.fill: parent
            keys: ["arrowhead", "startCircle"]
            onPositionChanged: drag => {
                                   drag.source.x = -drag.source.parent.x
                                   + arrowDropArea.parent.x + arrowDropArea.parent.width / 2
                                   drag.source.y = -drag.source.parent.y
                                   + arrowDropArea.parent.y + arrowDropArea.parent.height
                               }
            onEntered: parent.color = hoverColor
            onExited: parent.color = "transparent"
            onDropped: drop => {
                           parent.color = "transparent"
                           drop.acceptProposedAction()
                           drop.source.cardID = cardID
                           drop.source.direction = "south"
                       }
        }
    }

    Rectangle {
        id: southwest
        x: -width / 2
        y: -height / 2 + arrowDropArea.parent.height
        width: areaRadius
        height: width
        radius: width / 2
        color: "transparent"

        DropArea {
            anchors.fill: parent
            keys: ["arrowhead", "startCircle"]
            onPositionChanged: drag => {
                                   drag.source.x = -drag.source.parent.x + arrowDropArea.parent.x
                                   drag.source.y = -drag.source.parent.y
                                   + arrowDropArea.parent.y + arrowDropArea.parent.height
                               }
            onEntered: parent.color = hoverColor
            onExited: parent.color = "transparent"
            onDropped: drop => {
                           parent.color = "transparent"
                           drop.acceptProposedAction()
                           drop.source.cardID = cardID
                           drop.source.direction = "southwest"
                       }
        }
    }

    Rectangle {
        id: west
        x: -width / 2
        y: -height / 2 + arrowDropArea.parent.height / 2
        width: areaRadius
        height: width
        radius: width / 2
        color: "transparent"

        DropArea {
            anchors.fill: parent
            keys: ["arrowhead", "startCircle"]
            onPositionChanged: drag => {
                                   drag.source.x = -drag.source.parent.x + arrowDropArea.parent.x
                                   drag.source.y = -drag.source.parent.y
                                   + arrowDropArea.parent.y + arrowDropArea.parent.height / 2
                               }
            onEntered: parent.color = hoverColor
            onExited: parent.color = "transparent"
            onDropped: drop => {
                           parent.color = "transparent"
                           drop.acceptProposedAction()
                           drop.source.cardID = cardID
                           drop.source.direction = "west"
                       }
        }
    }
}
