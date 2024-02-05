#include "preferencesmanager.h"

#include <QDesktopServices>

PreferencesManager::PreferencesManager(QQmlApplicationEngine* engine, QObject* parent)
    : m_engine(engine)
    , QObject { parent }
{
    QString path = QCoreApplication::applicationDirPath() + "/config/settings.json";
    m_settings = new QSettings(path, JsonFormat);
}

QJSValue PreferencesManager::camera()
{
    QJSValue camera = m_engine->newArray(3);
    camera.setProperty("x", m_settings->value("view/camera/x").toReal());
    camera.setProperty("y", m_settings->value("view/camera/y").toReal());
    camera.setProperty("zoomFactor", m_settings->value("view/camera/zoomFactor").toReal());
    return camera;
}

void PreferencesManager::setCamera(QJSValue camera)
{
    qreal x = camera.property("x").toNumber();
    qreal y = camera.property("y").toNumber();
    qreal zoomFactor = camera.property("zoomFactor").toNumber();
    m_settings->setValue("view/camera/x", x);
    m_settings->setValue("view/camera/y", y);
    m_settings->setValue("view/camera/zoomFactor", zoomFactor);
    emit cameraChanged();
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

QString PreferencesManager::fontName()
{
    return m_settings->value("appearance/fontName").toString();
}

void PreferencesManager::setFontName(QString fontName)
{
    m_settings->setValue("appearance/fontName", fontName);
    emit fontNameChanged();
}

void PreferencesManager::openSaveDir()
{
    QString path = QCoreApplication::applicationDirPath() + "/save";
    QDesktopServices::openUrl("file:///" + path);
}
