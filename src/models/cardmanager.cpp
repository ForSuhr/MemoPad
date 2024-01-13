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
    qDeleteAll(m_cardMap.begin(), m_cardMap.end());
    m_cardMap.clear();
    qDeleteAll(m_canvasMap.begin(), m_canvasMap.end());
    m_canvasMap.clear();
}

int CardManager::cardNum()
{
    return m_cardMap.count();
}

QStringList CardManager::cardIDs()
{
    return m_cardMap.keys();
}

QString CardManager::cardType(QString cardID)
{
    return m_cardMap[cardID]->m_cardType;
}

qreal CardManager::x(QString cardID)
{
    return m_cardMap[cardID]->m_x;
}

void CardManager::setX(QString cardID, qreal x)
{
    m_cardMap[cardID]->m_x = x;
    m_IO->setValue(m_currentCanvasID + "/" + cardID + "/x", x);
}

qreal CardManager::y(QString cardID)
{
    return m_cardMap[cardID]->m_y;
}

void CardManager::setY(QString cardID, qreal y)
{
    m_cardMap[cardID]->m_y = y;
    m_IO->setValue(m_currentCanvasID + "/" + cardID + "/y", y);
}

qreal CardManager::z(QString cardID)
{
    return m_cardMap[cardID]->m_z;
}

void CardManager::setZ(QString cardID, qreal z)
{
    m_cardMap[cardID]->m_z = z;
    m_IO->setValue(m_currentCanvasID + "/" + cardID + "/z", z);
}

QSizeF CardManager::pos(QString cardID)
{
    return QSizeF(x(cardID), y(cardID));
}

void CardManager::setPos(QString cardID, qreal x, qreal y, qreal z)
{
    setX(cardID, x);
    setY(cardID, y);
    setZ(cardID, z);
}

qreal CardManager::width(QString cardID)
{
    return m_cardMap[cardID]->m_width;
}

void CardManager::setWidth(QString cardID, qreal width)
{
    m_cardMap[cardID]->m_width = width;
    m_IO->setValue(m_currentCanvasID + "/" + cardID + "/width", width);
}

qreal CardManager::height(QString cardID)
{
    return m_cardMap[cardID]->m_height;
}

void CardManager::setHeight(QString cardID, qreal height)
{
    m_cardMap[cardID]->m_height = height;
    m_IO->setValue(m_currentCanvasID + "/" + cardID + "/height", height);
}

QSizeF CardManager::size(QString cardID)
{
    return QSizeF(width(cardID), height(cardID));
}

void CardManager::setSize(QString cardID, qreal width, qreal height)
{
    setWidth(cardID, width);
    setHeight(cardID, height);
}

QString CardManager::backgroundColor(QString cardID)
{
    return m_cardMap[cardID]->m_backgroundColor;
}

void CardManager::setBackgroundColor(QString cardID, QString backgroundColor)
{
    m_cardMap[cardID]->m_backgroundColor = backgroundColor;
    m_IO->setValue(m_currentCanvasID + "/" + cardID + "/backgroundColor", backgroundColor);
}

QString CardManager::text(QString cardID)
{
    return m_cardMap[cardID]->m_text;
}

void CardManager::setText(QString cardID, QString text)
{
    m_cardMap[cardID]->m_text = text;
    m_IO->setValue(m_currentCanvasID + "/" + cardID + "/text", text);
}

QString CardManager::image(QString cardID)
{
    QUrl url = m_cardMap[cardID]->m_image;
    QString source = url.toString();
    QFileInfo fileInfo(url.toLocalFile());
    if (fileInfo.isDir() | !fileInfo.exists())
        source = "qrc:/MemoPad/ui/assets/themes/lumos/image.svg";
    return source;
}

void CardManager::setImage(QString cardID, QUrl imageUrl)
{
    // get string path from url
    QString imageSource = imageUrl.toLocalFile();

    // clear the previous image
    QString previousImage = QCoreApplication::applicationDirPath() + "/save/images/" + m_IO->value(m_currentCanvasID + "/" + cardID + "/image").toString();
    QFile file(previousImage);
    if (file.exists())
        file.remove();

    // set new image
    QFileInfo fileInfo(imageSource);
    QString fileName = fileInfo.fileName();
    QString dirPath = QCoreApplication::applicationDirPath() + "/save/images/";
    if (!QDir(dirPath).exists())
        QDir().mkpath(dirPath);
    QString imageTarget = dirPath + fileName;
    if (QFile::exists(imageTarget)) {
        QString timestamp = QDateTime::currentDateTime().toString("yyyyMMddHHmmss");
        fileName = fileInfo.baseName() + "_" + timestamp + "." + fileInfo.suffix();
        imageTarget = dirPath + fileName;
    }
    QFile::copy(imageSource, imageTarget);
    m_cardMap[cardID]->m_image = "file:///" + imageTarget; // qml need URI to work
    m_IO->setValue(m_currentCanvasID + "/" + cardID + "/image", fileName);
}

QString CardManager::canvasID(QString cardID)
{
    return m_canvasMap[cardID]->m_canvasID;
}

void CardManager::setCanvasID(QString cardID, QString canvasID)
{
    m_canvasMap[cardID]->m_canvasID = canvasID;
    m_IO->setValue(m_currentCanvasID + "/" + cardID + "/canvasID", canvasID);
}

QString CardManager::canvasName(QString cardID)
{
    return m_canvasMap[cardID]->m_canvasName;
}

void CardManager::setCanvasName(QString cardID, QString canvasName)
{
    m_canvasMap[cardID]->m_canvasName = canvasName;
    m_IO->setValue(m_currentCanvasID + "/" + cardID + "/canvasName", canvasName);
}

QString CardManager::currentCanvasID()
{
    return m_currentCanvasID;
}

QString CardManager::upperCanvasID()
{
    return m_upperCanvasID;
}

void CardManager::setCurrentCanvasColor(QString canvasColor)
{
    m_IO->setValue(m_currentCanvasID + "/" + "/canvasColor", canvasColor);
}

QString CardManager::currentCanvasColor()
{
    return m_IO->value(m_currentCanvasID + "/" + "/canvasColor").toString();
}

QString CardManager::createCard(QString cardType)
{
    QString cardID = uuid();
    Card* card = new Card(cardID, cardType);
    m_cardMap[cardID] = card;
    m_IO->setValue(m_currentCanvasID + "/" + cardID + "/cardType", cardType);
    return cardID;
}

void CardManager::deleteCard(QString cardID)
{
    /*remove all sub-canvases that the cardID refers to recursively (in case this cardID belongs to a card of type "canvas")*/
    deleteCanvasByCanvasCard(cardID, m_currentCanvasID);

    /*remove it from memory*/
    m_cardMap.remove(cardID);

    /*remove this card from disk*/
    m_IO->beginGroup(m_currentCanvasID);
    m_IO->remove(cardID);
    m_IO->endGroup();
}

/// @brief a recursive function for deleting all sub-canvases by a canvas card id
void CardManager::deleteCanvasByCanvasCard(QString cardID, QString currentCanvasID)
{
    m_IO->beginGroup(currentCanvasID);
    QStringList keys = m_IO->childGroups();
    m_IO->endGroup();
    for (int i = 0; i < keys.count(); i++) {
        QString cardID = keys[i];
        QString cardType = m_IO->value(currentCanvasID + "/" + cardID + "/cardType").toString();

        // if currentCanvasID == m_currentCanvasID,
        // meaning that this is the first time this recursive function being called
        // in this case, if this card doesn't match the card id we passed in,  jump over this iteration
        if (currentCanvasID == m_currentCanvasID & cardID != cardID)
            continue;

        if (cardType == "canvas") {
            QString canvasID = m_IO->value(currentCanvasID + "/" + cardID + "/canvasID").toString();
            deleteCanvasByCanvasCard(cardID, canvasID);
            m_IO->remove(canvasID);
        }
    }
}

/// @brief load cards from canvas file to m_cardMap
void CardManager::loadCards()
{
    m_IO->beginGroup(m_currentCanvasID);
    QStringList keys = m_IO->childGroups(); // stringlist of all cards' uuid
    for (int i = 0; i < keys.count(); i++) {
        QString cardID = keys[i];
        QString cardType = m_IO->value(cardID + "/cardType").toString();
        Card* card = new Card(cardID, cardType);
        card->m_x = m_IO->value(cardID + "/x").toReal();
        card->m_y = m_IO->value(cardID + "/y").toReal();
        card->m_z = m_IO->value(cardID + "/z").toReal();
        card->m_width = m_IO->value(cardID + "/width").toReal();
        card->m_height = m_IO->value(cardID + "/height").toReal();
        card->m_text = m_IO->value(cardID + "/text").toString();
        card->m_image = "file:///" + QCoreApplication::applicationDirPath() + "/save/images/" + m_IO->value(cardID + "/image").toString();
        card->m_backgroundColor = m_IO->value(cardID + "/backgroundColor").toString();
        card->m_canvasID = m_IO->value(cardID + "/canvasID").toString();
        card->m_canvasName = m_IO->value(cardID + "/canvasName").toString();
        m_cardMap[cardID] = card;
    }
    m_IO->endGroup();
}

QString CardManager::createCanvas(QString cardID, QString canvasName)
{
    QString canvasID = uuid();
    Canvas* canvas = new Canvas(canvasID, canvasName, m_currentCanvasID);
    m_canvasMap[cardID] = canvas;
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
