cmake_minimum_required(VERSION 3.16)

project(MemoPad VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.2 REQUIRED COMPONENTS Quick)

qt_add_executable(MemoPad
    main.cpp
)

qt_add_qml_module(MemoPad
    URI MemoPad
    VERSION 1.0
    RESOURCES
    SOURCES
        models/texteditor.h
        models/texteditor.cpp
    QML_FILES
        ui/Main.qml
        ui/TextEditor.qml
        ui/BackgroundCanvas.qml
        ui/SideToolBar.qml
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
