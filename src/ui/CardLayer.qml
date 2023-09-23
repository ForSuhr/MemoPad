import QtQuick

Item {
    id: root
    width: parent.width
    height: parent.height
    anchors.fill: parent

    // once you click on cardlayer(it means that you clicked on somewhere outside the cards),
    // the cards will lose their focus, and they should be marked as unselected
    MouseArea {
        id: loseFocus
        anchors.fill: parent
        onPressed: {
            for (var i = 1; i < parent.children.length; i++) {
                parent.children[i].selected = false
            }
        }
    }
}
