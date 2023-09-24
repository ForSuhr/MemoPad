#include "cardmanager.h"

CardManager::CardManager(QObject* parent)
    : QObject { parent }
{
}

CardManager::~CardManager()
{
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
