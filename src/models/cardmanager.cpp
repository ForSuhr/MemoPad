#include "cardmanager.h"

CardManager::CardManager(QObject* parent)
    : QObject { parent }
{
    // setup IO
    QString path = QCoreApplication::applicationDirPath() + "/save/canvas.json";
    m_IO = new QSettings(path, JsonFormat);
}

CardManager::~CardManager()
{
    for (auto i = m_cardMap.begin(); i != m_cardMap.end(); i++) {
        delete i.value();
    }

    for (auto i = m_canvasMap.begin(); i != m_canvasMap.end(); i++) {
        delete i.value();
    }
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
    m_IO->setValue(m_currentCanvasID + "/" + id + "/x", x);
}

qreal CardManager::y(QString id)
{
    return m_cardMap[id]->m_y;
}

void CardManager::setY(QString id, qreal y)
{
    m_cardMap[id]->m_y = y;
    m_IO->setValue(m_currentCanvasID + "/" + id + "/y", y);
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
    m_IO->setValue(m_currentCanvasID + "/" + id + "/width", width);
}

qreal CardManager::height(QString id)
{
    return m_cardMap[id]->m_height;
}

void CardManager::setHeight(QString id, qreal height)
{
    m_cardMap[id]->m_height = height;
    m_IO->setValue(m_currentCanvasID + "/" + id + "/height", height);
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
    m_IO->setValue(m_currentCanvasID + "/" + id + "/backgroundColor", backgroundColor);
}

QString CardManager::text(QString id)
{
    return m_cardMap[id]->m_text;
}

void CardManager::setText(QString id, QString text)
{
    m_cardMap[id]->m_text = text;
    m_IO->setValue(m_currentCanvasID + "/" + id + "/text", text);
}

QString CardManager::canvasID(QString id)
{
    return m_canvasMap[id]->m_canvasID;
}

void CardManager::setCanvasID(QString id, QString canvasID)
{
    m_canvasMap[id]->m_canvasID = canvasID;
    m_IO->setValue(m_currentCanvasID + "/" + id + "/canvasID", canvasID);
}

QString CardManager::canvasName(QString id)
{
    return m_canvasMap[id]->m_canvasName;
}

void CardManager::setCanvasName(QString id, QString canvasName)
{
    m_canvasMap[id]->m_canvasName = canvasName;
    m_IO->setValue(m_currentCanvasID + "/" + id + "/canvasName", canvasName);
}

QString CardManager::currentCanvasID()
{
    return m_currentCanvasID;
}

QString CardManager::upperCanvasID()
{
    return m_upperCanvasID;
}

QString CardManager::createCard(QString cardType)
{
    QString id = uuid();
    Card* card = new Card(id, cardType);
    m_cardMap[id] = card;
    m_IO->setValue(m_currentCanvasID + "/" + id + "/cardType", cardType);
    return id;
}

void CardManager::deleteCard(QString id)
{
    /*remove this card from disk*/
    m_IO->beginGroup(m_currentCanvasID);
    m_IO->remove(id);
    m_IO->endGroup();

    /*if this card of type "canvas", remove the canvas it refers to as well*/
    if (m_cardMap[id]->m_cardType == "canvas") {
        QString canvasID = m_cardMap[id]->m_canvasID;
        m_IO->remove(canvasID);
    }

    /*remove it from memory*/
    m_cardMap.remove(id);
}

/// @brief load cards from canvas file to m_cardMap
void CardManager::loadCards()
{
    m_IO->beginGroup(m_currentCanvasID);
    QStringList keys = m_IO->childGroups(); // stringlist of all cards' uuid
    for (int i = 0; i < keys.count(); i++) {
        QString cardType = m_IO->value(keys[i] + "/cardType").toString();
        Card* card = new Card(keys[i], cardType);
        card->m_x = m_IO->value(keys[i] + "/x").toReal();
        card->m_y = m_IO->value(keys[i] + "/y").toReal();
        card->m_width = m_IO->value(keys[i] + "/width").toReal();
        card->m_height = m_IO->value(keys[i] + "/height").toReal();
        card->m_text = m_IO->value(keys[i] + "/text").toString();
        card->m_backgroundColor = m_IO->value(keys[i] + "/backgroundColor").toString();
        card->m_canvasID = m_IO->value(keys[i] + "/canvasID").toString();
        card->m_canvasName = m_IO->value(keys[i] + "/canvasName").toString();
        m_cardMap[keys[i]] = card;
    }
    m_IO->endGroup();
}

QString CardManager::createCanvas(QString id, QString canvasName)
{
    QString canvasID = uuid();
    Canvas* canvas = new Canvas(canvasID, canvasName, m_currentCanvasID);
    m_canvasMap[id] = canvas;
    m_IO->setValue(canvasID + "/canvasName", canvasName);
    m_IO->setValue(canvasID + "/upperCanvasID", m_currentCanvasID);
    return canvasID;
}

void CardManager::loadCanvas(QString newCanvasID)
{
    // check if newCanvasID exists
    QStringList canvasList = m_IO->childGroups();
    if (!canvasList.contains(newCanvasID))
        return;

    // initialize canvas map
    m_IO->beginGroup(newCanvasID);
    QStringList keys = m_IO->childGroups();
    for (int i = 0; i < keys.count(); i++) {
        QString cardType = m_IO->value(keys[i] + "/cardType").toString();
        if (cardType == "canvas") {
            QString canvasID = m_IO->value(keys[i] + "/canvasID").toString();
            QString canvasName = m_IO->value(keys[i] + "/canvasName").toString();
            Canvas* canvas = new Canvas(canvasID, canvasName, newCanvasID);
            m_canvasMap[keys[i]] = canvas;
        }
    }
    m_IO->endGroup();

    // clear current card map
    for (auto i = m_cardMap.begin(); i != m_cardMap.end(); i++) {
        delete i.value();
    }
    m_cardMap.clear();

    // load new cards into card map
    m_upperCanvasID = m_IO->value(newCanvasID + "/upperCanvasID").toString();
    m_currentCanvasID = newCanvasID;
    emit currentCanvasIDChanged(newCanvasID);
    loadCards();
}

QString CardManager::uuid()
{
    return QUuid::createUuid().toString(QUuid::WithoutBraces);
}
