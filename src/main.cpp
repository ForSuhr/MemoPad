#include <QGuiApplication>
#include <QIcon>
#include <QQmlApplicationEngine>

#include "models/cardmanager.h"
#include "models/commandmanager.h"
#include "models/preferencesmanager.h"

int main(int argc, char* argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    /*qml register*/
    qmlRegisterSingletonType(QUrl(QStringLiteral("qrc:/MemoPad/ui/Globals.qml")), "MemoPad.Globals", 1, 0, "Globals");
    qmlRegisterSingletonType(QUrl(QStringLiteral("qrc:/MemoPad/ui/IconSet.qml")), "MemoPad.IconSet", 1, 0, "IconSet");
    qmlRegisterSingletonType(QUrl(QStringLiteral("qrc:/MemoPad/ui/style/Style.qml")), "MemoPad.Style", 1, 0, "Style");
    QScopedPointer<CardManager> scopedPointer1(new CardManager);
    qmlRegisterSingletonInstance("MemoPad.CardManager", 1, 0, "CardManager", scopedPointer1.get());
    QScopedPointer<PreferencesManager> scopedPointer2(new PreferencesManager(&engine));
    qmlRegisterSingletonInstance("MemoPad.PreferencesManager", 1, 0, "PreferencesManager", scopedPointer2.get());
    QScopedPointer<CommandManager> scopedPointer3(new CommandManager);
    qmlRegisterSingletonInstance("MemoPad.CommandManager", 1, 0, "CommandManager", scopedPointer3.get());

    const QUrl url(u"qrc:/MemoPad/ui/Main.qml"_qs);
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreated, &app,
        [url](QObject* obj, const QUrl& objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);

    /*window icon*/
    app.setWindowIcon(QIcon(":/MemoPad/ui/assets/icon/MemoPad.png"));

    return app.exec();
}
