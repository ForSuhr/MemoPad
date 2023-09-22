import QtQuick

Item {
    id: root
    width: 32
    height: 32

    property bool created: false

    Rectangle {
        id: rect
        width: root.width
        height: root.height
        color: "red"
    }

    onCreatedChanged: {
        console.log("new card created")
    }

    MouseArea {
        id: mouseArea
        width: root.width
        height: root.height
        drag.target: root
    }
}
