#ifndef PREFERENCESMANAGER_H
#define PREFERENCESMANAGER_H

#include <QCoreApplication>
#include <QObject>

#include "qsettingsjson.h"

class PreferencesManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString toolBarArea READ toolBarArea WRITE setToolBarArea NOTIFY toolBarAreaChanged)
public:
    explicit PreferencesManager(QObject* parent = nullptr);

    QString toolBarArea();
    void setToolBarArea(QString toolBarArea);

signals:
    void toolBarAreaChanged();

private:
    QSettings* m_settings = nullptr;
};

#endif // PREFERENCESMANAGER_H
