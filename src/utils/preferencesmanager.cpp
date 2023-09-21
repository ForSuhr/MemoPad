#include "preferencesmanager.h"

PreferencesManager::PreferencesManager(QObject* parent)
    : QObject { parent }
{
    QString path = QCoreApplication::applicationDirPath() + "/config/settings.json";
    m_settings = new QSettings(path, JsonFormat);
    qInfo() << "preferences path: " << path;
}

QString PreferencesManager::toolBarArea()
{
    return m_settings->value("layout/toolBarArea").toString();
}

void PreferencesManager::setToolBarArea(QString toolBarArea)
{
    m_settings->setValue("layout/toolBarArea", toolBarArea);
}
