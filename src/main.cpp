#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "models/texteditor.h"

int main(int argc, char* argv[])
{
    QGuiApplication app(argc, argv);

    /*qml register*/
    qmlRegisterType<TextEditor>("ForSuhr.TextEditorModel", 1, 0, "TextEditorModel");

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
