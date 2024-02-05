#ifndef PREFERENCESMANAGER_H
#define PREFERENCESMANAGER_H

#include <QCoreApplication>
#include <QJSValue>
#include <QObject>
#include <QQmlApplicationEngine>

#include "../utils/qsettingsjson.h"

class PreferencesManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(QJSValue camera READ camera WRITE setCamera NOTIFY cameraChanged FINAL)
    Q_PROPERTY(QString floatingBarArea READ floatingBarArea WRITE setFloatingBarArea NOTIFY floatingBarAreaChanged FINAL)
    Q_PROPERTY(bool cardSizeAutoAdjust READ cardSizeAutoAdjust WRITE setCardSizeAutoAdjust NOTIFY cardSizeAutoAdjustChanged FINAL)
    Q_PROPERTY(bool fullScreenMode READ fullScreenMode WRITE setFullScreenMode NOTIFY fullScreenModeChanged FINAL)
    Q_PROPERTY(int fontSize READ fontSize WRITE setFontSize NOTIFY fontSizeChanged FINAL)
    Q_PROPERTY(QString fontName READ fontName WRITE setFontName NOTIFY fontNameChanged FINAL)
public:
    explicit PreferencesManager(QQmlApplicationEngine* engine, QObject* parent = nullptr);

    QJSValue camera();
    void setCamera(QJSValue camera);
    QString floatingBarArea();
    void setFloatingBarArea(QString floatingBarArea);
    bool cardSizeAutoAdjust();
    void setCardSizeAutoAdjust(bool cardSizeAutoAdjust);
    bool fullScreenMode();
    void setFullScreenMode(bool fullScreenMode);
    int fontSize();
    void setFontSize(int fontSize);
    QString fontName();
    void setFontName(QString fontName);

    Q_INVOKABLE void openSaveDir();

signals:
    void cameraChanged();
    void floatingBarAreaChanged();
    void cardSizeAutoAdjustChanged();
    void fullScreenModeChanged();
    void fontSizeChanged();
    void fontNameChanged();

private:
    QQmlApplicationEngine* m_engine = nullptr;
    QSettings* m_settings = nullptr;
};

#endif // PREFERENCESMANAGER_H
