import QtQuick

Item {
    id: arrowDropArea

    property int areaRadius: 40

    Rectangle {
        id: northwestCorner
        x: -width / 2
        y: -height / 2
        width: areaRadius
        height: width
        radius: width / 2
        color: "transparent"

        DropArea {
            id: dropArea
            anchors.fill: parent
            keys: ["arrowhead"]
            onPositionChanged: drag => {
                                   drag.source.x = arrowDropArea.parent.x - drag.source.parent.x
                                   drag.source.y = arrowDropArea.parent.y - drag.source.parent.y
                               }
            onEntered: parent.color = "#22000000"
            onExited: parent.color = "transparent"
            onDropped: drop => {
                           parent.color = "transparent"
                           drop.acceptProposedAction()
                           drop.source.parent.toCardID = cardID
                       }
        }
    }
}
