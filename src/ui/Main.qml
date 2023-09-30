import QtQuick
import QtQuick.Controls
import MemoPad
import MemoPad.TextEditorModel
import MemoPad.PreferencesManager
import MemoPad.CardManager
import MemoPad.CommandManager
import "IO.js" as IO

Window {
    id: window
    width: 1280
    height: 720
    visible: true
    visibility: Globals.fullScreenMode ? Window.FullScreen : Window.Windowed
    title: qsTr("MemoPad")
    color: "floralwhite"

    Component.onCompleted: IO.load()

    Canvas {
        id: bgCanvas
        width: window.width * 2
        height: window.height * 2
    }

    FloatingBar {
        id: floatingBar
        width: window.width
        height: window.height
        floatingBarArea: PreferencesManager.floatingBarArea
        onFloatingBarAreaChangedUI: area => {
                                        PreferencesManager.floatingBarArea = area
                                    }
    }
}
