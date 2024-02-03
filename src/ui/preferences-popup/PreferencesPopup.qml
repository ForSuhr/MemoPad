import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MemoPad.Globals

Popup {
    id: root
    width: 510
    height: 400
    anchors.centerIn: parent
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    clip: true
    verticalPadding: 0
    horizontalPadding: 5
    background: Rectangle {
        color: "ghostwhite"
        radius: 15
        border.width: 2
        border.color: "lightgray"
    }

    property int fontPixelSize: Globals.fontPixelSize16
    property string selectedColor: "lightsteelblue"
    property string hoveredColor: "gainsboro"

    RowLayout {
        anchors.verticalCenter: parent.verticalCenter
        spacing: 0

        ListView {
            id: listView
            width: 100
            height: 360
            orientation: Qt.Vertical
            currentIndex: 0
            focus: true
            model: ListModel {
                ListElement {
                    title: qsTr("Common")
                    page: "preferencesPage1.qml"
                }
                ListElement {
                    title: qsTr("About")
                    page: "preferencesPage2.qml"
                }
            }
            delegate: Item {
                width: 80
                height: 40
                anchors.horizontalCenter: parent.horizontalCenter
                Rectangle {
                    width: 80
                    height: 36
                    color: "transparent"
                    radius: 10
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            listView.currentIndex = index
                            stackView.push(model.page)
                            parent.color = "transparent"
                        }
                        onContainsMouseChanged: {
                            if (listView.currentIndex !== index)
                                if (containsMouse)
                                    parent.color = hoveredColor
                                else
                                    parent.color = "transparent"
                        }
                    }
                    Text {
                        anchors.centerIn: parent
                        text: model.title
                        font.pixelSize: fontPixelSize
                    }
                }
            }
            highlight: HighlightBar {}
            highlightFollowsCurrentItem: false
        }

        component HighlightBar: Rectangle {
            width: 80
            height: 36
            radius: 10
            color: selectedColor
            x: listView.currentItem.x
            y: listView.currentItem.y
        }

        Rectangle {
            id: dividingLine
            width: 2
            height: root.height
            color: "lightgray"
        }

        StackView {
            id: stackView
            width: 400
            height: 400
            initialItem: "preferencesPage1.qml"
            pushEnter: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 200
                }
            }
            pushExit: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 200
                }
            }
        }
    }
}
