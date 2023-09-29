#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "models/cardmanager.h"
#include "models/preferencesmanager.h"
#include "models/texteditor.h"

int main(int argc, char* argv[])
{
    QGuiApplication app(argc, argv);

    /*qml register*/
    qmlRegisterType<TextEditor>("MemoPad.TextEditorModel", 1, 0, "TextEditorModel");
    QScopedPointer<CardManager> scopedPointer1(new CardManager);
    qmlRegisterSingletonInstance("MemoPad.CardManager", 1, 0, "CardManager", scopedPointer1.get());
    QScopedPointer<PreferencesManager> scopedPointer2(new PreferencesManager);
    qmlRegisterSingletonInstance("MemoPad.PreferencesManager", 1, 0, "PreferencesManager", scopedPointer2.get());

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
