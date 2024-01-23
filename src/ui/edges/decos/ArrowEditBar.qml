import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../js/IO.js" as IO
import MemoPad.CardManager
import MemoPad.CommandManager
import MemoPad.IconSet

Pane {
    id: cardEditBar

    property int itemNum: 6
    property string borderColor: "gainsboro"

    width: 32 * itemNum + 16
    height: 32

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

    RowLayout {
        width: 24 * itemNum + 16
        height: 24
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
        ArrowEditBarItem {
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
