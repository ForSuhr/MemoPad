import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import MemoPad.PreferencesManager

Page {
    id: commonPage

    property int fontPixelSize: Globals.fontPixelSize16
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

        ColumnLayout {
            width: 300
            height: 300
            spacing: 30

            Item {
                id: cardSizeAutoAdjust
                width: 300
                height: 30
                RowLayout {
                    width: parent.width
                    height: parent.height
                    Label {
                        Layout.alignment: Qt.AlignVCenter
                        text: qsTr("Card size adjusts with text")
                        font.pixelSize: fontPixelSize
                    }
                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }
                    Switch {
                        width: 80
                        height: 30
                        Layout.alignment: Qt.AlignVCenter
                        checked: Globals.cardSizeAutoAdjust
                        onCheckedChanged: {
                            Globals.cardSizeAutoAdjust = checked
                            PreferencesManager.cardSizeAutoAdjust = checked
                        }
                    }
                }
            }

            Item {
                id: fullScreen
                width: 300
                height: 30
                RowLayout {
                    width: parent.width
                    height: parent.height
                    Label {
                        Layout.alignment: Qt.AlignVCenter
                        text: qsTr("FullScreen Mode")
                        font.pixelSize: fontPixelSize
                    }
                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }
                    Switch {
                        width: 80
                        height: 30
                        Layout.alignment: Qt.AlignVCenter
                        checked: Globals.fullScreenMode
                        onCheckedChanged: {
                            Globals.fullScreenMode = checked
                            PreferencesManager.fullScreenMode = checked
                        }
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }
}
