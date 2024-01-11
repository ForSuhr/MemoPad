import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MemoPad.CardManager
import MemoPad.CommandManager
import MemoPad.PreferencesManager
import "../preferences-popup"
import MemoPad.Globals
import MemoPad.IconSet

Item {
    id: root

    property string topAreaKey: "top area"
    property string bottomAreaKey: "bottom area"

    FloatingBarArea {
        id: topArea
        x: root.x
        y: root.y
        width: root.parent.width
        height: root.parent.height / 6
        visible: false
        key: topAreaKey
        onFloatingBarDropped: {
            floatingBar.x = topArea.x + (topArea.width - floatingBar.width) / 2
            floatingBar.y = topArea.y + (topArea.height - floatingBar.height) / 2
            PreferencesManager.floatingBarArea = topAreaKey
            Globals.floatingBarArea = topAreaKey
        }
    }

    FloatingBarArea {
        id: bottomArea
        x: root.x
        y: root.y + root.height * 5 / 6
        width: root.parent.width
        height: root.parent.height / 6
        visible: false
        key: bottomAreaKey
        onFloatingBarDropped: {
            floatingBar.x = bottomArea.x + (bottomArea.width - floatingBar.width) / 2
            floatingBar.y = bottomArea.y + (bottomArea.height - floatingBar.height) / 2
            PreferencesManager.floatingBarArea = bottomAreaKey
            Globals.floatingBarArea = bottomAreaKey
        }
    }

    FloatingBar {
        id: floatingBar
    }

    CanvasPalette {
        id: canvasPalette
    }

    /*settings window*/
    PreferencesPopup {
        id: preferencesPopup
    }

    /*undo&redo button*/
    FloatingButton {
        id: undo
        x: 42
        y: root.height - height - 42
        width: 32
        height: 32
        imageSource: IconSet.undo
        buttonAction: "undo"
        actionEnabled: false
        Connections {
            target: CommandManager
            function onUndoStackEmptySignal(isEmpty) {
                undo.actionEnabled = !isEmpty
            }
        }
    }

    FloatingButton {
        id: redo
        x: root.width - width - 42
        y: root.height - height - 42
        width: 32
        height: 32
        imageSource: IconSet.redo
        buttonAction: "redo"
        actionEnabled: false
        Connections {
            target: CommandManager
            function onRedoStackEmptySignal(isEmpty) {
                redo.actionEnabled = !isEmpty
            }
        }
    }

    /*back to upper canvas button*/
    FloatingButton {
        id: back
        x: 42
        y: 42
        width: 32
        height: 32
        imageSource: IconSet.back
        buttonAction: "back"
        actionEnabled: Globals.currentCanvasID === Globals.initialCanvasID ? false : true
        // event handler on canvas changed
        Connections {
            target: CardManager
            function onCurrentCanvasIDChanged(newCanvasID) {
                Globals.currentCanvasID = newCanvasID
                Globals.canvasColor = CardManager.currentCanvasColor()
            }
        }
    }
}
