import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "IO.js" as IO
import MemoPad.CardManager
import MemoPad.CommandManager
import QtQuick.Dialogs
import Qt.labs.platform

Pane {
    id: cardEditBar

    property int itemNum: 6
    property string borderColor: "gainsboro"

    width: 32 * itemNum
    height: 32
    anchors.horizontalCenter: cardEditBar.parent.horizontalCenter
    anchors.bottom: cardEditBar.parent.top
    anchors.bottomMargin: 10
    opacity: enabled
    visible: false
    background: Rectangle {
        opacity: enabled ? 1 : 0.5
        radius: 10
        color: "white"
        border.width: 2
        border.color: borderColor
    }

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        folder: StandardPaths.writableLocation(StandardPaths.PicturesLocation)
        onAccepted: {
            console.log("Open: " + fileDialog.currentFile)
            cardEditBar.parent.imageSource = fileDialog.currentFile
        }
        onRejected: {
            console.log("Canceled")
        }
    }

    RowLayout {
        width: 32 * itemNum - 16
        height: 24
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
        CardEditBarItem {
            width: parent.height
            height: parent.height
            imageSource: IconSet.uploadImage
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: fileDialog.open()
                onEntered: cursorShape = Qt.PointingHandCursor
                onExited: cursorShape = Qt.ArrowCursor
            }
        }
        CardEditBarItem {
            width: parent.height
            height: parent.height
            imageSource: IconSet.trash
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: IO.deleteCard(cardEditBar.parent.id,
                                         cardEditBar.parent)
                onEntered: cursorShape = Qt.PointingHandCursor
                onExited: cursorShape = Qt.ArrowCursor
            }
        }
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
