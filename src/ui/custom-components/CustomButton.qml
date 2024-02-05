import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

Button {
    id: control
    font.pixelSize: 16
    width: 120
    height: 30

    property bool hasIcon: false
    property bool hasText: false

    property string iconPath: ""
    property string themeType: "light"
    property real iconScale: 1

    MouseArea {
        id: mouseArea
        anchors.fill: control
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.NoButton
    }

    contentItem: RowLayout {
        width: parent.width
        height: parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        Image {
            visible: hasIcon
            fillMode: Image.PreserveAspectCrop
            mipmap: true
            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
            sourceSize: Qt.size(control.implicitWidth * iconScale,
                                control.implicitHeight * iconScale)
            source: iconPath
        }
        Text {
            visible: hasText
            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
            text: control.text
            font: control.font
            opacity: enabled ? 1.0 : 0.3
            color: "black"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
    }

    background: Rectangle {
        id: backgroundRect
        implicitWidth: control.width
        implicitHeight: control.height
        color: "ghostwhite"
        radius: 5
        border.width: 1
        border.color: "lightgray"
        clip: true

        Behavior on color {
            ColorAnimation {
                easing.type: Easing.InOutQuad
                duration: 200
            }
        }

        Rectangle {
            id: wave
            property int mX
            property int mY
            x: mX - width / 2
            y: mY - height / 2
            height: width
            radius: width / 2
            color: themeType === "light" ? Qt.darker(backgroundRect.color,
                                                     1.2) : Qt.lighter(
                                               backgroundRect.color, 1.2)
        }
    }

    ParallelAnimation {
        id: waveAnimation
        PropertyAnimation {
            target: wave
            property: "width"
            from: 0
            to: control.width * 2
            duration: 200
        }
        PropertyAnimation {
            target: wave
            property: "opacity"
            from: 1
            to: 0
            duration: 200
        }
    }

    DropShadow {
        anchors.fill: backgroundRect
        source: backgroundRect
        radius: 5
        color: "gainsboro"
    }

    onPressed: {
        wave.mX = mouseArea.mouseX
        wave.mY = mouseArea.mouseY
        waveAnimation.restart()
    }
}
