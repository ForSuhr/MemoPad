cmake_minimum_required(VERSION 3.16)

project(MemoPad VERSION 1.0 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.2 REQUIRED COMPONENTS Quick)

qt_add_executable(MemoPad
    main.cpp
)

set_source_files_properties(ui/Globals.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)
set_source_files_properties(ui/IconSet.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_qml_module(MemoPad
    URI MemoPad
    VERSION 1.0
    RESOURCES
        ui/assets/themes/lumos/blank.svg
        ui/assets/themes/lumos/canvas.svg
        ui/assets/themes/lumos/note.svg
        ui/assets/themes/lumos/trash.svg
        ui/assets/themes/lumos/gear.svg
    SOURCES
        models/card.h
        models/card.cpp
        models/texteditor.h
        models/texteditor.cpp
        models/cardmanager.h
        models/cardmanager.cpp
        models/preferencesmanager.h
        models/preferencesmanager.cpp
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
        ui/TextEditor.qml
        ui/BackgroundCanvas.qml
        ui/SideToolBar.qml
        ui/SideToolBarArea.qml
        ui/SideToolBarItem.qml
        ui/CardLayer.qml
        ui/ResizableItem.qml
        ui/NoteCard.qml
        ui/CanvasCard.qml
        ui/CardPalette.qml
        ui/CardEditBar.qml
        ui/CardEditBarItem.qml
        ui/PreferencesPopup.qml
        ui/preferencesPage1.qml
        ui/preferencesPage2.qml
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
