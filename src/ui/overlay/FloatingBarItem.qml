import QtQuick
import MemoPad.Globals
import "../js/CardCreator.js" as CardCreator

/* once you drag a item from floatingBar, a new card (a card is something you placed in the canvas and take you note) will be created according to this component file */
Item {
    id: root

    property string componentFile
    property string imageSource: IconSet.blank
    property bool enableMouseArea: true

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
            enabled: enableMouseArea
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onEntered: {
                if (Globals.floatingBarArea === "top area")
                    floatDown.start()
                else if (Globals.floatingBarArea === "bottom area")
                    floatUp.start()
            }
            onExited: floatBack.start()
            onPressed: mouse => {
                           cursorShape = Qt.ClosedHandCursor
                           CardCreator.startDrag(mouse)
                       }
            onPositionChanged: mouse => CardCreator.continueDrag(mouse)
            onReleased: mouse => {
                            cursorShape = Qt.PointingHandCursor
                            CardCreator.endDrag(mouse)
                        }
        }
    }
}
