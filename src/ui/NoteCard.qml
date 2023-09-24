import QtQuick
import QtQuick.Controls
import "Snap.js" as Snap

ResizableItem {
    id: root
    width: 160
    height: 64

    property bool created: false
    property bool selected: false

    onCreatedChanged: console.log("new card created")
    onSelectedChanged: {
        isVisble = selected
        textArea.focus = false
        dragArea.enabled = true
    }

    MouseArea {
        id: dragArea
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
            textArea.focus = true
            enabled = false
        }
    }

    TextArea {
        id: textArea
        z: 0
        width: root.width
        height: root.height
        anchors.centerIn: parent
        topPadding: 15
        bottomPadding: 15
        leftPadding: 20
        rightPadding: 20
        background: Rectangle {
            color: "snow"
            border.width: 4
            border.color: "gainsboro"
            radius: 10
        }
        wrapMode: TextEdit.Wrap
        font.pixelSize: 24
        color: "black"
        selectByMouse: true
        selectionColor: "aliceblue"
        selectedTextColor: "black"
        activeFocusOnPress: false
        activeFocusOnTab: false

        // adjust text area according to contents automatically
        onContentHeightChanged: root.height = contentHeight + topPadding + bottomPadding
    }
}
