#include "cardmanager.h"

CardManager::CardManager(QObject* parent)
    : QObject { parent }
{
    QString path = QCoreApplication::applicationDirPath() + "/save/canvas.json";
    m_cardIO = new QSettings(path, JsonFormat);
}

CardManager::~CardManager()
{
}

int CardManager::cardNum()
{
    return m_cardList.count();
}

QString CardManager::cardType(int index)
{
    return m_cardList[index].m_cardType;
}

qreal CardManager::x(int index)
{
    return m_cardList[index].m_x;
}

void CardManager::setX(int index, qreal x)
{
    m_cardList[index].m_x = x;
    m_cardIO->setValue(m_currentCanvas + "/" + QString::number(index) + "/x", x);
}

qreal CardManager::y(int index)
{
    return m_cardList[index].m_y;
}

void CardManager::setY(int index, qreal y)
{
    m_cardList[index].m_y = y;
    m_cardIO->setValue(m_currentCanvas + "/" + QString::number(index) + "/y", y);
}

qreal CardManager::width(int index)
{
    return m_cardList[index].m_width;
}

void CardManager::setWidth(int index, qreal width)
{
    m_cardList[index].m_width = width;
    m_cardIO->setValue(m_currentCanvas + "/" + QString::number(index) + "/width", width);
}

qreal CardManager::height(int index)
{
    return m_cardList[index].m_height;
}

void CardManager::setHeight(int index, qreal height)
{
    m_cardList[index].m_height = height;
    m_cardIO->setValue(m_currentCanvas + "/" + QString::number(index) + "/height", height);
}

int CardManager::createCard(QString cardType)
{
    int index = m_cardList.count();
    Card card(index, cardType);
    m_cardList.append(card);
    m_cardIO->setValue(m_currentCanvas + "/" + QString::number(index) + "/cardType", cardType);
    m_cardIO->setValue(m_currentCanvas + "/cardNum", m_cardList.count());
    return index;
}

/// @brief load cards from canvas file to m_cardList
void CardManager::loadCards()
{
    qInfo() << "loading";
    m_cardIO->beginGroup(m_currentCanvas);
    int cardNum = m_cardIO->value("cardNum").toInt();
    for (int i = 0; i < cardNum; i++) {
        QString cardNumString = QString::number(i);
        QString cardType = m_cardIO->value(cardNumString + "/cardType").toString();
        Card card(i, cardType);
        card.m_x = m_cardIO->value(cardNumString + "/x").toReal();
        card.m_y = m_cardIO->value(cardNumString + "/y").toReal();
        card.m_width = m_cardIO->value(cardNumString + "/width").toReal();
        card.m_height = m_cardIO->value(cardNumString + "/height").toReal();
        m_cardList.append(card);
    }
    m_cardIO->endGroup();
    listCards();
}

void CardManager::listCards()
{
    for (int i = 0; i < m_cardList.count(); i++)
        qInfo() << "index: " << m_cardList[i].m_index << "; cardType: " << m_cardList[i].m_cardType;
}
