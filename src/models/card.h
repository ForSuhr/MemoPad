#ifndef CARD_H
#define CARD_H

#include <QDebug>
#include <QObject>

class Card {

public:
    explicit Card(int index, QString cardType);

    int m_index;
    QString m_cardType;
    qreal m_x;
    qreal m_y;
    qreal m_width;
    qreal m_height;
    QString m_backgroundColor;
};

#endif // CARD_H
