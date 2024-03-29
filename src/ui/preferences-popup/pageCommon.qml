import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import MemoPad.PreferencesManager
import MemoPad.Globals
import MemoPad.IconSet
import "../custom-components"

Page {
    id: commonPage

    property int fontPixelSize: 16
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
                        text: qsTr("Adjust card size to fit text")
                        color: "black"
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
                        color: "black"
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
                id: openSaveDir
                width: 300
                height: 30
                RowLayout {
                    width: parent.width
                    height: parent.height
                    Label {
                        Layout.alignment: Qt.AlignVCenter
                        text: qsTr("Open Save Directory")
                        color: "black"
                        font.pixelSize: fontPixelSize
                    }
                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }
                    CustomButton {
                        id: openSaveDirBtn
                        width: 50
                        hasIcon: true
                        themeType: "light"
                        iconPath: IconSet.folder
                        iconScale: 0.5
                        onClicked: PreferencesManager.openSaveDir()
                    }
                }
            }
            LayoutSpacer {}
        }
    }
}
