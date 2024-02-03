#include "preferencesmanager.h"

PreferencesManager::PreferencesManager(QObject* parent)
    : QObject { parent }
{
    QString path = QCoreApplication::applicationDirPath() + "/config/settings.json";
    m_settings = new QSettings(path, JsonFormat);
}

QString PreferencesManager::floatingBarArea()
{
    return m_settings->value("layout/floatingBarArea").toString();
}

void PreferencesManager::setFloatingBarArea(QString floatingBarArea)
{
    m_settings->setValue("layout/floatingBarArea", floatingBarArea);
    emit floatingBarAreaChanged();
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

bool PreferencesManager::fullScreenMode()
{
    return m_settings->value("common/fullScreenMode").toBool();
}

void PreferencesManager::setFullScreenMode(bool fullScreenMode)
{
    m_settings->setValue("common/fullScreenMode", fullScreenMode);
    emit fullScreenModeChanged();
}

int PreferencesManager::fontSize()
{
    return m_settings->value("appearance/fontSize").toInt();
}

void PreferencesManager::setFontSize(int fontSize)
{
    m_settings->setValue("appearance/fontSize", fontSize);
    emit fontSizeChanged();
}
