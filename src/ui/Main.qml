import QtQuick
import QtQuick.Controls
import MemoPad.Globals
import MemoPad.IconSet
import MemoPad.PreferencesManager
import MemoPad.CardManager
import MemoPad.CommandManager
import "js/IO.js" as IO
import "overlay"

Window {
    id: window
    width: 1280
    height: 720
    visible: true
    visibility: Globals.fullScreenMode ? Window.FullScreen : Window.Windowed
    title: qsTr("MemoPad")
    color: Globals.canvasColor

    // load initial canvas, "canvas 0" is the ID of the initial canvas
    Component.onCompleted: IO.load(Globals.initialCanvasID)

    CanvasBoard {
        id: bgCanvas
        width: window.width * 2
        height: window.height * 2
    }

    Overlay {
        id: overlay
        width: window.width
        height: window.height
    }

    MShortCut {
        id: shortCut
    }
}
