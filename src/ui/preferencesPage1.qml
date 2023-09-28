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

            Item {
                id: cardSizeAutoAdjust
                RowLayout {
                    width: 300
                    height: 30
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
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }
}
