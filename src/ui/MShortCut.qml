import QtQuick
import MemoPad.CommandManager

Item {
    id: root

    Shortcut {
        sequences: [StandardKey.Undo]
        onActivated: CommandManager.undo()
    }

    Shortcut {
        sequences: [StandardKey.Redo]
        onActivated: CommandManager.redo()
    }
}
