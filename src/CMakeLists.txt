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
        ui/assets/themes/lumos/trash.svg
        ui/assets/themes/lumos/gear.svg
        ui/assets/themes/lumos/undo.svg
        ui/assets/themes/lumos/redo.svg
        ui/assets/themes/lumos/back.svg
        ui/assets/themes/lumos/doorClosed.svg
        ui/assets/themes/lumos/doorOpen.svg
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
        #[[javascript]]
        ui/CardCreator.js
        ui/Snap.js
        ui/IO.js
        #[[qml]]
        ui/CanvasBoard.qml
        ui/FloatingBar.qml
        ui/FloatingBarArea.qml
        ui/FloatingBarItem.qml
        ui/FloatingButton.qml
        ui/CardLayer.qml
        ui/ResizableItem.qml
        ui/CanvasCard.qml
        ui/NoteCard.qml
         ui/ImageCard.qml
        ui/CardPalette.qml
        ui/CardEditBar.qml
        ui/CardEditBarItem.qml
        ui/PreferencesPopup.qml
        ui/preferencesPage1.qml
        ui/preferencesPage2.qml
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
