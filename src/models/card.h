#ifndef CARD_H
#define CARD_H

#include <QDebug>
#include <QObject>

class Card {

public:
    explicit Card(int index, QString cardType);

    int m_index;
    QString m_cardType;
};

#endif // CARD_H
