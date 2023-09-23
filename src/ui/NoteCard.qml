import QtQuick

ResizableItem {
    id: root
    width: 128
    height: 64

    property bool created: false
    property bool selected: false

    onCreatedChanged: console.log("new card created")
    onSelectedChanged: isVisble = selected

    MouseArea {
        id: dragArea
        anchors.fill: parent
        drag.target: root
        drag.minimumX: 0
        drag.minimumY: 0
        drag.maximumX: root.parent.width - root.width
        drag.maximumY: root.parent.height - root.height
        onClicked: selected = true
        onPressed: cursorShape = Qt.ClosedHandCursor
        onReleased: cursorShape = Qt.ArrowCursor
    }

    Rectangle {
        id: rect
        z: 0
        width: root.width
        height: root.height
        color: "snow"
        border.width: 4
        border.color: "gainsboro"
        radius: 10
    }
}
