import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import MemoPad.Globals
import MemoPad.PreferencesManager

Popup {
    id: root
    anchors.centerIn: Overlay.overlay
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    background: Rectangle {
        color: "ghostwhite"
        radius: 15
        border.width: 2
        border.color: "lightgray"
    }

    property var model: undefined
    property alias currentFontName: comboBox.currentText

    property int rowHeight: 36

    ListModel {
        id: fontListModel
    }

    ListModel {
        id: comboboxListModel
    }

    function resetListModel() {
        fontListModel.clear()
        comboboxListModel.clear()
        var fontList = model
        for (var i = 0; i < fontList.length; i++) {
            fontListModel.append({
                                     "name": fontList[i]
                                 })
            comboboxListModel.append({
                                         "name": fontList[i]
                                     })
        }
    }
    ColumnLayout {
        Label {
            height: rowHeight
            text: qsTr("Font name :  ") + Globals.fontName
            color: "black"
            font.pixelSize: 16
        }

        RowLayout {
            width: 400
            height: rowHeight

            TextField {
                id: filterTextField
                width: 150
                height: 36
                placeholderText: qsTr("type in font name")
                color: "black"
                placeholderTextColor: "lightgray"
                cursorVisible: true
                font.pixelSize: 16
                background: Rectangle {
                    implicitWidth: filterTextField.width
                    implicitHeight: rowHeight
                    color: "ghostwhite"
                    radius: 5
                    border.width: filterTextField.activeFocus ? 2 : 1
                    border.color: filterTextField.activeFocus ? "darkgray" : "lightgray"
                }

                onTextChanged: {
                    text = text.toLowerCase()
                    comboboxListModel.clear()
                    for (var i = 0; i < fontListModel.count; i++) {
                        var fontName = fontListModel.get(i).name
                        if (fontName.toLowerCase().indexOf(text) !== -1)
                            comboboxListModel.append(fontListModel.get(i))
                    }
                    comboBox.popup.open()
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            CustomComboBox {
                id: comboBox
                width: 250
                height: rowHeight
                model: comboboxListModel
                Component.onCompleted: resetListModel()
                onActivated: {
                    Globals.fontName = textAt(currentIndex)
                    PreferencesManager.fontName = textAt(currentIndex)
                }
            }
        }
    }
}
