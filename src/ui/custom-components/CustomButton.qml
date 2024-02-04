import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic

Button {
    id: control
    font.pixelSize: 16
    background: Rectangle {
        implicitWidth: 120
        implicitHeight: 30
        color: "ghostwhite"
        radius: 5
        border.width: 1
        border.color: "lightgray"
    }
    contentItem: Text {
        text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        color: "black"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
}
