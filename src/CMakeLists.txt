cmake_minimum_required(VERSION 3.16)

project(MemoPad VERSION 1.0 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_add_executable(MemoPad
    main.cpp
    "ui/assets/icon/MemoPad.rc"
)

set_source_files_properties(ui/Globals.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)
set_source_files_properties(ui/IconSet.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_qml_module(MemoPad
    URI MemoPad
    VERSION 1.0
    RESOURCES
        #[[app icon]]
        ui/assets/themes/lumos/blank.svg
        ui/assets/themes/lumos/canvas.svg
        ui/assets/themes/lumos/note.svg
        ui/assets/themes/lumos/image.svg
        ui/assets/themes/lumos/arrow.svg
        ui/assets/themes/lumos/arrow-solid.svg
        ui/assets/themes/lumos/arrow-dash.svg
        ui/assets/themes/lumos/trash.svg
        ui/assets/themes/lumos/upload-image.svg
        ui/assets/themes/lumos/gear.svg
        ui/assets/themes/lumos/palette.svg
        ui/assets/themes/lumos/undo.svg
        ui/assets/themes/lumos/redo.svg
        ui/assets/themes/lumos/back.svg
        ui/assets/themes/lumos/shutdown.svg
        ui/assets/themes/lumos/door-closed.svg
        ui/assets/themes/lumos/door-open.svg
        #[[window icon]]
        ui/assets/icon/MemoPad.png
    SOURCES
        models/card.h
        models/card.cpp
        models/canvas.h
        models/canvas.cpp
        models/cardmanager.h
        models/cardmanager.cpp
        models/preferencesmanager.h
        models/preferencesmanager.cpp
        models/command.h
        models/commands.h
        models/commandmanager.h
        models/commandmanager.cpp
        utils/qsettingsjson.h
        utils/qsettingsjson.cpp
    QML_FILES
        #[[main]]
        ui/Main.qml
        #[[singleton]]
        ui/Globals.qml
        ui/IconSet.qml
        #[[style]]
        ui/style/Style.qml
        #[[javascript]]
        ui/js/CardCreator.js
        ui/js/Snap.js
        ui/js/IO.js
        #[[nodes]]
        ui/nodes/ResizableItem.qml
        ui/nodes/CanvasCard.qml
        ui/nodes/NoteCard.qml
        ui/nodes/ImageCard.qml
        #[[nodes/decos]]
        ui/nodes/decos/ArrowDropArea.qml
        ui/nodes/decos/CardPalette.qml
        ui/nodes/decos/CardEditBar.qml
        ui/nodes/decos/CardEditBarItem.qml
        ui/nodes/decos/ImageCardEditBar.qml
        #[[edges]]
        ui/edges/Arrow.qml
        #[[edges/decos]]
        ui/edges/decos/ArrowEditBar.qml
        ui/edges/decos/ArrowEditBarItem.qml
        #[[overlay]]
        ui/overlay/Overlay.qml
        ui/overlay/FloatingBar.qml
        ui/overlay/FloatingBarArea.qml
        ui/overlay/FloatingBarItem.qml
        ui/overlay/FloatingButton.qml
        ui/overlay/CanvasPalette.qml
        #[[preferences-popup]]
        ui/preferences-popup/PreferencesPopup.qml
        ui/preferences-popup/pageCommon.qml
        ui/preferences-popup/pageAppearance.qml
        ui/preferences-popup/pageAbout.qml
        #[[miscellaneous]]
        ui/CanvasBoard.qml
        ui/NodeLayer.qml
        ui/EdgeLayer.qml
        ui/MShortCut.qml
)

set_target_properties(MemoPad PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER ForSuhr.MemoPad
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(MemoPad
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS MemoPad
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
