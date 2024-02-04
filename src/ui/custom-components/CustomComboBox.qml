import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts

ComboBox {
    id: control
    model: undefined
    textRole: "name"
    font.pixelSize: 16

    contentItem: Text {
        height: contentHeight
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        text: currentText
        color: "black"
        font: control.font
        elide: Text.ElideRight
    }
    background: Rectangle {
        implicitWidth: control.width
        implicitHeight: control.height
        color: "ghostwhite"
        radius: 5
        border.width: control.activeFocus ? 2 : 1
        border.color: control.activeFocus ? "darkgray" : "lightgray"
    }
    delegate: ItemDelegate {
        id: delegate
        width: control.width

        required property var model
        required property int index

        contentItem: Text {
            text: delegate.model[control.textRole]
            color: "black"
            font: control.font
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }
        background: Rectangle {
            width: control.width - 25
            radius: 5
            color: delegate.hovered ? "lightgray" : "ghostwhite"
        }
    }

    popup: Popup {
        y: control.height + 5
        width: control.implicitWidth
        height: contentItem.implicitHeight > 300 ? 300 : contentItem.implicitHeight + 25
        contentItem: ListView {
            implicitWidth: contentWidth
            implicitHeight: contentHeight
            model: control.delegateModel
            keyNavigationEnabled: true
            currentIndex: control.highlightedIndex
            clip: true
            focus: true
        }
        background: Rectangle {
            implicitWidth: control.width
            implicitHeight: control.height
            color: "ghostwhite"
            radius: 5
            border.width: 1
            border.color: "lightgray"
            clip: true
        }
        onOpened: fadeIn.start()
    }

    ParallelAnimation {
        id: fadeIn
        PropertyAnimation {
            target: popup
            property: "scale"
            from: 0.9
            to: 1
            duration: 50
        }
        PropertyAnimation {
            target: popup
            property: "opacity"
            from: 0.9
            to: 1
            duration: 50
        }
    }
}
