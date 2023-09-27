import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic

Page {
    id: aboutPage

    property int fontPixelSize: Globals.fontPixelSize16
    property string creatorText: "<b>Creator</b>" + "<br><br>"
                                 + "ForSuhr - <a href=https://github.com/ForSuhr/MemoPad>GitHub</a>"
    property string qtText: "<b>Third Party Licenses</b>" + "<br><br>"
                            + "Qt6.3.2 - LGPL v3  - <a href=https://www.qt.io>https://www.qt.io</a>"

    width: 400
    height: 400
    background: Rectangle {
        color: "transparent"
    }

    ScrollView {
        id: view
        width: 400
        height: 400
        anchors.fill: parent
        rightPadding: parent.rightPadding
        bottomPadding: parent.rightPadding
        padding: 50
        TextArea {
            id: textArea
            readOnly: true
            font.pixelSize: fontPixelSize
            wrapMode: TextArea.Wrap
            textFormat: TextArea.RichText
            text: creatorText + "<br><br><br>" + qtText
            onLinkActivated: link => {
                                 Qt.openUrlExternally(link)
                             }
        }
    }
}
