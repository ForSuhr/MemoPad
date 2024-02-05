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

    //floating bar
    property string floatingBarArea: "top area"

    /*----------preferences----------*/
    /*page commom*/
    property bool cardSizeAutoAdjust: false
    property bool fullScreenMode: false

    /*page appearance*/
    property int fontSize: 20
    property string fontName: "Arial"

    Component.onCompleted: {
        /*canvas*/
        camera = PreferencesManager.camera
        floatingBarArea = PreferencesManager.floatingBarArea
        /*page commom*/
        cardSizeAutoAdjust = PreferencesManager.cardSizeAutoAdjust
        fullScreenMode = PreferencesManager.fullScreenMode
        /*page appearance*/
        fontSize = PreferencesManager.fontSize !== "" ? PreferencesManager.fontSize : 20
        fontName = PreferencesManager.fontName !== "" ? PreferencesManager.fontName : "Arial"
    }
}
