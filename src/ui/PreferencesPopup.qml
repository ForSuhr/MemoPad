import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Popup {
    id: root

    property int fontPixelSize: Globals.fontPixelSize16
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
                    color: listView.currentIndex === index ? "lightsteelblue" : "transparent"
                    radius: 10
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            listView.currentIndex = index
                            stackView.push(model.page)
                        }
                        //                        onEntered: {
                        //                            if (listView.currentIndex !== index)
                        //                                parent.color = "aliceblue"
                        //                        }
                        //                        onExited: {
                        //                            if (listView.currentIndex !== index)
                        //                                parent.color = "transparent"
                        //                        }
                    }
                    Text {
                        anchors.centerIn: parent
                        text: model.title
                        font.pixelSize: fontPixelSize
                    }
                }
            }
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
