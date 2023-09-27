pragma Singleton

import QtQuick
import MemoPad.PreferencesManager

QtObject {
    /*canvas*/
    property real dotSize: 1.0
    property int dotInterval: 20

    /*font*/
    property int fontPixelSize16: 16
    property int fontPixelSize24: 24
    property int fontPixelSize36: 36

    /*----------preferences----------*/
    /*page1*/
    property bool cardSizeAutoAdjust: PreferencesManager.cardSizeAutoAdjust
}
