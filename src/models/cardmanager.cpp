#include "cardmanager.h"

CardManager::CardManager(QObject* parent)
    : QObject { parent }
{
}

CardManager::~CardManager()
{
}

qreal CardManager::x(int index)
{
    return m_cardList[index].m_x;
}

void CardManager::setX(int index, qreal x)
{
    m_cardList[index].m_x = x;
}

qreal CardManager::y(int index)
{
    return m_cardList[index].m_y;
}

void CardManager::setY(int index, qreal y)
{
    m_cardList[index].m_y = y;
}

qreal CardManager::width(int index)
{
    return m_cardList[index].m_width;
}

void CardManager::setWidth(int index, qreal width)
{
    m_cardList[index].m_width = width;
}

qreal CardManager::height(int index)
{
    return m_cardList[index].m_height;
}

void CardManager::setHeight(int index, qreal height)
{
    m_cardList[index].m_height = height;
}

int CardManager::createCard(QString cardType)
{
    int index = m_cardList.count();
    Card card(index, cardType);
    m_cardList.append(card);
    return index;
}

void CardManager::listCards()
{
    for (int i = 0; i < m_cardList.count(); i++)
        qInfo() << "index: " << m_cardList[i].m_index << "; cardType: " << m_cardList[i].m_cardType;
}
