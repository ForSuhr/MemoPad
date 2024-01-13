import QtQuick

Item {
    id: floatingBarArea
    opacity: 0.5

    property string key: "unknown area"
    signal floatingBarDropped

    DropArea {
        id: dropArea
        width: floatingBarArea.width
        height: floatingBarArea.height
        Rectangle {
            id: rect
            width: dropArea.width
            height: dropArea.height
            anchors.centerIn: dropArea
            color: "lightgray"
            opacity: 0.5
        }

        keys: [key] // a list of keys that the drop area will accept

        onDropped: drop => {
                       floatingBarDropped()
                       drop.acceptProposedAction()
                   }
    }
}
