import QtQuick

Item {
    id: root
    property string imageSource: "assets/themes/lumos/blank.svg"

    Rectangle {
        id: rect
        width: root.width
        height: root.height
        anchors.fill: root
        color: "transparent"
        Image {
            id: image
            anchors.fill: rect
            source: imageSource
            sourceSize: Qt.size(rect.width, rect.height)
            fillMode: Image.PreserveAspectFit
        }
    }
}
