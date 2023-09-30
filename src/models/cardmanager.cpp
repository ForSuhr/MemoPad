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
    return m_cardMap.count();
}

QStringList CardManager::cardIDs()
{
    return m_cardMap.keys();
}

QString CardManager::cardType(QString id)
{
    return m_cardMap[id]->m_cardType;
}

qreal CardManager::x(QString id)
{
    return m_cardMap[id]->m_x;
}

void CardManager::setX(QString id, qreal x)
{
    m_cardMap[id]->m_x = x;
    m_cardIO->setValue(m_currentCanvas + "/" + id + "/x", x);
}

qreal CardManager::y(QString id)
{
    return m_cardMap[id]->m_y;
}

void CardManager::setY(QString id, qreal y)
{
    m_cardMap[id]->m_y = y;
    m_cardIO->setValue(m_currentCanvas + "/" + id + "/y", y);
}

QSizeF CardManager::pos(QString id)
{
    return QSizeF(x(id), y(id));
}

void CardManager::setPos(QString id, qreal x, qreal y)
{
    setX(id, x);
    setY(id, y);
}

qreal CardManager::width(QString id)
{
    return m_cardMap[id]->m_width;
}

void CardManager::setWidth(QString id, qreal width)
{
    m_cardMap[id]->m_width = width;
    m_cardIO->setValue(m_currentCanvas + "/" + id + "/width", width);
}

qreal CardManager::height(QString id)
{
    return m_cardMap[id]->m_height;
}

void CardManager::setHeight(QString id, qreal height)
{
    m_cardMap[id]->m_height = height;
    m_cardIO->setValue(m_currentCanvas + "/" + id + "/height", height);
}

QSizeF CardManager::size(QString id)
{
    return QSizeF(width(id), height(id));
}

void CardManager::setSize(QString id, qreal width, qreal height)
{
    setWidth(id, width);
    setHeight(id, height);
}

QString CardManager::backgroundColor(QString id)
{
    return m_cardMap[id]->m_backgroundColor;
}

void CardManager::setBackgroundColor(QString id, QString backgroundColor)
{
    m_cardMap[id]->m_backgroundColor = backgroundColor;
    m_cardIO->setValue(m_currentCanvas + "/" + id + "/backgroundColor", backgroundColor);
}

QString CardManager::text(QString id)
{
    return m_cardMap[id]->m_text;
}

void CardManager::setText(QString id, QString text)
{
    m_cardMap[id]->m_text = text;
    m_cardIO->setValue(m_currentCanvas + "/" + id + "/text", text);
}

QString CardManager::createCard(QString cardType)
{
    QString id = uuid();
    Card* card = new Card(id, cardType);
    m_cardMap[id] = card;
    m_cardIO->setValue(m_currentCanvas + "/" + id + "/cardType", cardType);
    return id;
}

void CardManager::deleteCard(QString id)
{
    m_cardMap.remove(id);
    m_cardIO->beginGroup(m_currentCanvas);
    m_cardIO->remove(id);
    m_cardIO->endGroup();
}

/// @brief load cards from canvas file to m_cardMap
void CardManager::loadCards()
{
    m_cardIO->beginGroup(m_currentCanvas);
    QStringList keys = m_cardIO->childGroups();
    for (int i = 0; i < keys.count(); i++) {
        QString cardType = m_cardIO->value(keys[i] + "/cardType").toString();
        Card* card = new Card(keys[i], cardType);
        card->m_x = m_cardIO->value(keys[i] + "/x").toReal();
        card->m_y = m_cardIO->value(keys[i] + "/y").toReal();
        card->m_width = m_cardIO->value(keys[i] + "/width").toReal();
        card->m_height = m_cardIO->value(keys[i] + "/height").toReal();
        card->m_text = m_cardIO->value(keys[i] + "/text").toString();
        card->m_backgroundColor = m_cardIO->value(keys[i] + "/backgroundColor").toString();
        m_cardMap[keys[i]] = card;
    }
    m_cardIO->endGroup();
}

QString CardManager::uuid()
{
    return QUuid::createUuid().toString(QUuid::WithoutBraces);
}
