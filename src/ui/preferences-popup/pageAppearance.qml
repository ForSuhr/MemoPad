import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import MemoPad.PreferencesManager
import MemoPad.Globals
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
                id: fontSize
                width: 300
                height: 30
                RowLayout {
                    width: parent.width
                    height: parent.height
                    Label {
                        Layout.alignment: Qt.AlignVCenter
                        text: qsTr("Font Size")
                        color: "black"
                        font.pixelSize: fontPixelSize
                    }
                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }
                    Slider {
                        id: slider
                        from: 10
                        to: 30
                        stepSize: 1
                        value: Globals.fontSize
                        snapMode: Slider.SnapAlways
                        onMoved: {
                            Globals.fontSize = value
                            PreferencesManager.fontSize = value
                        }
                        ToolTip {
                            width: 32
                            height: width
                            parent: slider.handle
                            visible: slider.pressed
                            background: Rectangle {
                                width: parent.width
                                height: width
                                radius: 5
                                color: "white"
                                border.color: "gainsboro"
                            }
                            contentItem: Text {
                                text: slider.value
                                color: "black"
                                font.pixelSize: 16
                            }
                        }
                    }
                }
            }

            Item {
                id: textFont
                width: 300
                height: 30
                RowLayout {
                    width: parent.width
                    height: parent.height
                    Label {
                        Layout.alignment: Qt.AlignVCenter
                        text: qsTr("Text Font")
                        color: "black"
                        font.pixelSize: fontPixelSize
                    }

                    LayoutSpacer {}

                    CustomButton {
                        id: fontPopupBtn
                        width: 120
                        text: Globals.fontName.length
                              <= 20 ? Globals.fontName : Globals.fontName.substring(
                                          0, 17) + "..."
                        themeType: "light"
                        onClicked: popup.open()
                    }

                    SearchableComboBox {
                        id: popup
                        model: Qt.fontFamilies()
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
