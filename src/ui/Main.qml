import QtQuick
import QtQuick.Controls
import ForSuhr.TextEditorModel
import ForSuhr.PreferencesManager
import MemoPad

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
