#ifndef PREFERENCESMANAGER_H
#define PREFERENCESMANAGER_H

#include <QCoreApplication>
#include <QObject>

#include "qsettingsjson.h"

class PreferencesManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString toolBarArea READ toolBarArea WRITE setToolBarArea NOTIFY toolBarAreaChanged FINAL)
    Q_PROPERTY(bool cardSizeAutoAdjust READ cardSizeAutoAdjust WRITE setCardSizeAutoAdjust NOTIFY cardSizeAutoAdjustChanged FINAL)
    Q_PROPERTY(bool fullScreenMode READ fullScreenMode WRITE setFullScreenMode NOTIFY fullScreenModeChanged FINAL)
public:
    explicit PreferencesManager(QObject* parent = nullptr);

    QString toolBarArea();
    void setToolBarArea(QString toolBarArea);
    bool cardSizeAutoAdjust();
    void setCardSizeAutoAdjust(bool cardSizeAutoAdjust);
    bool fullScreenMode();
    void setFullScreenMode(bool fullScreenMode);

signals:
    void toolBarAreaChanged();
    void cardSizeAutoAdjustChanged();
    void fullScreenModeChanged();

private:
    QSettings* m_settings = nullptr;
};

#endif // PREFERENCESMANAGER_H
