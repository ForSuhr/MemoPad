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

    QList<Card> m_cardList = {};

signals:

public slots:
    int createCard(QString cardType);
    void listCards();
};

#endif // CARDMANAGER_H
