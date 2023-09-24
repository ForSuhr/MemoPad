#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "models/cardmanager.h"
#include "models/texteditor.h"
#include "utils/preferencesmanager.h"

int main(int argc, char* argv[])
{
    QGuiApplication app(argc, argv);

    /*qml register*/
    qmlRegisterType<TextEditor>("MemoPad.TextEditorModel", 1, 0, "TextEditorModel");
    qmlRegisterType<PreferencesManager>("MemoPad.PreferencesManager", 1, 0, "PreferencesManager");
    qmlRegisterType<CardManager>("MemoPad.CardManager", 1, 0, "CardManager");

    QQmlApplicationEngine engine;
    const QUrl url(u"qrc:/MemoPad/ui/Main.qml"_qs);
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreated, &app,
        [url](QObject* obj, const QUrl& objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
