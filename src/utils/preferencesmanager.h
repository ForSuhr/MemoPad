#ifndef PREFERENCESMANAGER_H
#define PREFERENCESMANAGER_H

#include <QCoreApplication>
#include <QObject>

#include "qsettingsjson.h"

class PreferencesManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString toolBarArea READ toolBarArea WRITE setToolBarArea NOTIFY toolBarAreaChanged FINAL)
    Q_PROPERTY(bool cardSizeAutoAdjust READ cardSizeAutoAdjust WRITE setCardSizeAutoAdjust NOTIFY cardSizeAutoAdjustChanged FINAL)
public:
    explicit PreferencesManager(QObject* parent = nullptr);

    QString toolBarArea();
    void setToolBarArea(QString toolBarArea);
    bool cardSizeAutoAdjust();
    void setCardSizeAutoAdjust(bool cardSizeAutoAdjust);

signals:
    void toolBarAreaChanged();
    void cardSizeAutoAdjustChanged();

private:
    QSettings* m_settings = nullptr;
};

#endif // PREFERENCESMANAGER_H
