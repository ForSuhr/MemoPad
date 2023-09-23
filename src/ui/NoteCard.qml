import QtQuick

ResizableItem {
    id: root
    width: 128
    height: 64

    property bool created: false
    property bool selected: false

    onCreatedChanged: console.log("new card created")
    onSelectedChanged: isVisble = selected

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

    MouseArea {
        id: focusArea
        width: root.width
        height: root.height
        onClicked: selected = true
    }
}
