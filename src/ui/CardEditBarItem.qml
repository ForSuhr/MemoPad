import QtQuick

Item {
    id: root

    property string imageSource

    Rectangle {
        id: rect
        width: root.width
        height: root.height
        anchors.fill: root
        color: "transparent"
        Image {
            id: image
            x: 0
            y: 0
            source: imageSource
            sourceSize: Qt.size(rect.width, rect.height)
            fillMode: Image.PreserveAspectFit
        }
    }
}
