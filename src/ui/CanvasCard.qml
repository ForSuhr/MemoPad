import QtQuick
import QtQuick.Controls
import "Snap.js" as Snap
import MemoPad.CardManager

ResizableItem {
    id: root
    width: Globals.dotInterval * 3
    height: Globals.dotInterval * 3

    property int cardIndex
    property CardManager cardManager
    property bool created: false
    property bool selected: false

    onCreatedChanged: {
        console.log("canvas card created")
        cardIndex = cardManager.createCard("canvas")
        console.log("canvas", cardIndex)
    }
    onSelectedChanged: {
        isVisble = selected
        mouseArea.enabled = true
    }

    MouseArea {
        id: mouseArea
        z: 1
        anchors.fill: parent
        drag.target: root
        drag.minimumX: 0
        drag.minimumY: 0
        drag.maximumX: root.parent.width - root.width
        drag.maximumY: root.parent.height - root.height
        acceptedButtons: Qt.LeftButton
        onPressed: cursorShape = Qt.ClosedHandCursor
        onReleased: {
            cursorShape = Qt.ArrowCursor
            Snap.snap(root)
        }
        onClicked: {
            selected = true
            enabled = false
        }
    }

    Image {
        anchors.fill: parent
        source: "assets/themes/lumos/canvas.svg"
        antialiasing: true
    }
}
