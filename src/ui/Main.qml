import QtQuick
import QtQuick.Controls
import MemoPad
import MemoPad.TextEditorModel
import MemoPad.PreferencesManager
import MemoPad.CardManager

Window {
    id: window
    width: 1280
    height: 720
    visible: true
    title: qsTr("MemoPad")
    color: "floralwhite"

    PreferencesManager {
        id: preferencesManager
    }

    CardManager {
        id: cardManager
    }

    BackgroundCanvas {
        id: bgCanvas
        width: window.width * 2
        height: window.height * 2
    }

    SideToolBar {
        id: sideToolBar
        width: window.width
        height: window.height
        toolBarArea: preferencesManager.toolBarArea
        onToolBarAreaChangedUI: area => {
                                    preferencesManager.toolBarArea = area
                                }
    }
}
