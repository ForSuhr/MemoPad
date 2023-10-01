#ifndef CARD_H
#define CARD_H

#include <QString>

class Card {

public:
    explicit Card(QString id, QString cardType);

    QString m_id;
    QString m_cardType;
    qreal m_x;
    qreal m_y;
    qreal m_width;
    qreal m_height;
    QString m_text;
    QString m_backgroundColor;
    QString m_canvasID;
    QString m_canvasName;
};

#endif // CARD_H
