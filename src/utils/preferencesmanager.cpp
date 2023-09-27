#include "preferencesmanager.h"

PreferencesManager::PreferencesManager(QObject* parent)
    : QObject { parent }
{
    QString path = QCoreApplication::applicationDirPath() + "/config/settings.json";
    m_settings = new QSettings(path, JsonFormat);
}

QString PreferencesManager::toolBarArea()
{
    return m_settings->value("layout/toolBarArea").toString();
}

void PreferencesManager::setToolBarArea(QString toolBarArea)
{
    m_settings->setValue("layout/toolBarArea", toolBarArea);
    emit toolBarAreaChanged();
}

bool PreferencesManager::cardSizeAutoAdjust()
{
    return m_settings->value("common/cardSizeAutoAdjust").toBool();
}

void PreferencesManager::setCardSizeAutoAdjust(bool cardSizeAutoAdjust)
{
    m_settings->setValue("common/cardSizeAutoAdjust", cardSizeAutoAdjust);
    emit cardSizeAutoAdjustChanged();
}
