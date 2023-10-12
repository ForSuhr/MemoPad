pragma Singleton

import QtQuick
import MemoPad.PreferencesManager

QtObject {
    /*canvas*/
    property string initialCanvasID: "canvas 0"
    property string currentCanvasID: initialCanvasID
    property real dotSize: 1.0
    property int dotInterval: 20

    /*floating bar*/
    property string floatingBarArea: "top area"

    /*font*/
    property int fontPixelSize16: 16
    property int fontPixelSize24: 24
    property int fontPixelSize36: 36

    /*----------preferences----------*/
    /*page1*/
    property bool cardSizeAutoAdjust: false
    property bool fullScreenMode: false

    Component.onCompleted: {
        floatingBarArea = PreferencesManager.floatingBarArea
        cardSizeAutoAdjust = PreferencesManager.cardSizeAutoAdjust
        fullScreenMode = PreferencesManager.fullScreenMode
    }
}
