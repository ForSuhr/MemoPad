import QtQuick

Item {
    id: root

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
                                   drag.source.x = card.x
                                   drag.source.y = card.y
                               }
            onEntered: parent.color = "#66000000"
            onExited: parent.color = "transparent"
            onDropped: drag => {
                           console.log("dropped")
                           //toCardID = cardID
                       }
        }
    }
}
