#ifndef PREFERENCESMANAGER_H
#define PREFERENCESMANAGER_H

#include <QCoreApplication>
#include <QObject>

#include "../utils/qsettingsjson.h"

class PreferencesManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString floatingBarArea READ floatingBarArea WRITE setFloatingBarArea NOTIFY floatingBarAreaChanged FINAL)
    Q_PROPERTY(bool cardSizeAutoAdjust READ cardSizeAutoAdjust WRITE setCardSizeAutoAdjust NOTIFY cardSizeAutoAdjustChanged FINAL)
    Q_PROPERTY(bool fullScreenMode READ fullScreenMode WRITE setFullScreenMode NOTIFY fullScreenModeChanged FINAL)
    Q_PROPERTY(int fontSize READ fontSize WRITE setFontSize NOTIFY fontSizeChanged FINAL)
public:
    explicit PreferencesManager(QObject* parent = nullptr);

    QString floatingBarArea();
    void setFloatingBarArea(QString floatingBarArea);
    bool cardSizeAutoAdjust();
    void setCardSizeAutoAdjust(bool cardSizeAutoAdjust);
    bool fullScreenMode();
    void setFullScreenMode(bool fullScreenMode);
    int fontSize();
    void setFontSize(int fontSize);

signals:
    void floatingBarAreaChanged();
    void cardSizeAutoAdjustChanged();
    void fullScreenModeChanged();
    void fontSizeChanged();

private:
    QSettings* m_settings = nullptr;
};

#endif // PREFERENCESMANAGER_H
