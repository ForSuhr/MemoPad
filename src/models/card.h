#ifndef CARD_H
#define CARD_H

#include <QString>

class Card {

public:
    explicit Card(QString cardID, QString cardType);

    QString m_cardID;
    QString m_cardType;
    qreal m_x;
    qreal m_y;
    qreal m_z;
    qreal m_width;
    qreal m_height;
    QString m_text;
    QString m_image;
    QString m_backgroundColor;

    // canvas card
    QString m_canvasID;
    QString m_canvasName;

    // arrow card
    QString m_fromCardID;
    QString m_fromCardDirection;
    QString m_toCardID;
    QString m_toCardDirection;
    qreal m_fromX;
    qreal m_fromY;
    qreal m_toX;
    qreal m_toY;
    qreal m_controlX;
    qreal m_controlY;
};

#endif // CARD_H
