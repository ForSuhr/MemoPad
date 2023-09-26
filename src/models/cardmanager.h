#ifndef CARDMANAGER_H
#define CARDMANAGER_H

#include <QCoreApplication>
#include <QDebug>
#include <QMap>
#include <QObject>
#include <QUuid>

#include "../utils/qsettingsjson.h"
#include "card.h"

class CardManager : public QObject {
    Q_OBJECT
public:
    explicit CardManager(QObject* parent = nullptr);
    ~CardManager();

    Q_INVOKABLE int cardNum();
    Q_INVOKABLE QStringList cardIDs();
    Q_INVOKABLE QString cardType(QString id);
    Q_INVOKABLE qreal x(QString id);
    Q_INVOKABLE void setX(QString id, qreal x);
    Q_INVOKABLE qreal y(QString id);
    Q_INVOKABLE void setY(QString id, qreal y);
    Q_INVOKABLE qreal width(QString id);
    Q_INVOKABLE void setWidth(QString id, qreal width);
    Q_INVOKABLE qreal height(QString id);
    Q_INVOKABLE void setHeight(QString id, qreal height);
    Q_INVOKABLE QString backgroundColor(QString id);
    Q_INVOKABLE void setBackgroundColor(QString id, QString backgroundColor);
    Q_INVOKABLE QString text(QString id);
    Q_INVOKABLE void setText(QString id, QString text);

    QMap<QString, Card*> m_cardMap = {};

public slots:
    QString createCard(QString cardType);
    void deleteCard(QString id);
    void loadCards();

private:
    QString uuid();

    QString m_currentCanvas = "canvas 0";
    QSettings* m_cardIO = nullptr;
};

#endif // CARDMANAGER_H
