#ifndef CARDMANAGER_H
#define CARDMANAGER_H

#include <QDebug>
#include <QList>
#include <QObject>

#include "card.h"

class CardManager : public QObject {
    Q_OBJECT
public:
    explicit CardManager(QObject* parent = nullptr);
    ~CardManager();

    Q_INVOKABLE qreal x(int index);
    Q_INVOKABLE void setX(int index, qreal x);
    Q_INVOKABLE qreal y(int index);
    Q_INVOKABLE void setY(int index, qreal y);
    Q_INVOKABLE qreal width(int index);
    Q_INVOKABLE void setWidth(int index, qreal width);
    Q_INVOKABLE qreal height(int index);
    Q_INVOKABLE void setHeight(int index, qreal height);

    QList<Card> m_cardList = {};

public slots:
    int createCard(QString cardType);
    void listCards();
};

#endif // CARDMANAGER_H
