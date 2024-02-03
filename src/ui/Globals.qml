pragma Singleton

import QtQuick
import MemoPad.PreferencesManager

QtObject {
    /*canvas*/
    property var camera: {
        "x": -window.width / 2,
        "y": -window.height / 2,
        "zoomFactor": 1.0
    }

    property string initialCanvasID: "canvas 0"
    property string currentCanvasID: initialCanvasID
    property real dotSize: 1.0
    property int dotInterval: 20
    property string canvasColor: "floralwhite"

    /*floating bar*/
    property string floatingBarArea: "top area"

    /*font*/
    property int fontPixelSize16: 16
    property int fontPixelSize24: 24
    property int fontPixelSize36: 36

    /*----------preferences----------*/
    /*page commom*/
    property bool cardSizeAutoAdjust: false
    property bool fullScreenMode: false

    /*page appearance*/
    property int fontSize: 20

    Component.onCompleted: {
        camera = PreferencesManager.camera
        floatingBarArea = PreferencesManager.floatingBarArea
        cardSizeAutoAdjust = PreferencesManager.cardSizeAutoAdjust
        fullScreenMode = PreferencesManager.fullScreenMode
        fontSize = PreferencesManager.fontSize
    }
}
