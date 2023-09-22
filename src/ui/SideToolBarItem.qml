import QtQuick

Item {
    id: root
    property string imageSource: "assets/themes/lumos/blank.svg"
    property string toolBarArea: "top area"

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

        PropertyAnimation {
            id: floatUp
            target: image
            property: "y"
            to: -5
            duration: 100
        }

        PropertyAnimation {
            id: floatDown
            target: image
            property: "y"
            to: 5
            duration: 100
        }

        PropertyAnimation {
            id: floatBack
            target: image
            property: "y"
            to: 0
            duration: 100
        }

        MouseArea {
            id: mouseArea
            width: root.width
            height: root.height
            anchors.fill: rect
            hoverEnabled: true
            onEntered: {
                if (toolBarArea === "top area")
                    floatDown.start()
                else if (toolBarArea === "bottom area")
                    floatUp.start()
            }
            onExited: floatBack.start()
        }
    }
}
