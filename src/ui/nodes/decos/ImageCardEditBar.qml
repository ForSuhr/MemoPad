import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../js/IO.js" as IO
import MemoPad.CardManager
import MemoPad.CommandManager
import QtQuick.Dialogs
import Qt.labs.platform
import MemoPad.IconSet

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

    ScaleAnimator {
        id: scaleUp
        from: 1
        to: 1.1
        duration: 100
    }
    ScaleAnimator {
        id: scaleDown
        from: 1.1
        to: 1
        duration: 100
    }

    FileDialog {
        id: fileDialog
        title: qsTr("Choose an image")
        nameFilters: ["PNG files (*.png)", "JPEG files (*.jpg *.jpeg)", "SVG files (*.svg)"]
        folder: StandardPaths.writableLocation(StandardPaths.PicturesLocation)
        onAccepted: {
            IO.saveImage(cardID, fileDialog.currentFile)
            cardEditBar.parent.imageSource = CardManager.image(cardID)
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
                onEntered: {
                    scaleUp.target = parent
                    scaleUp.start()
                    cursorShape = Qt.PointingHandCursor
                }
                onExited: {
                    scaleDown.target = parent
                    scaleDown.start()
                    cursorShape = Qt.ArrowCursor
                }
            }
        }
        CardEditBarItem {
            width: parent.height
            height: parent.height
            imageSource: IconSet.trash
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: IO.deleteCard(cardEditBar.parent.cardID,
                                         cardEditBar.parent)
                onEntered: {
                    scaleUp.target = parent
                    scaleUp.start()
                    cursorShape = Qt.PointingHandCursor
                }
                onExited: {
                    scaleDown.target = parent
                    scaleDown.start()
                    cursorShape = Qt.ArrowCursor
                }
            }
        }
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
