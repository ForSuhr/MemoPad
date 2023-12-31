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

qreal CardManager::z(QString id)
{
    return m_cardMap[id]->m_z;
}

void CardManager::setZ(QString id, qreal z)
{
    m_cardMap[id]->m_z = z;
    m_IO->setValue(m_currentCanvasID + "/" + id + "/z", z);
}

QSizeF CardManager::pos(QString id)
{
    return QSizeF(x(id), y(id));
}

void CardManager::setPos(QString id, qreal x, qreal y, qreal z)
{
    setX(id, x);
    setY(id, y);
    setZ(id, z);
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

QString CardManager::image(QString id)
{
    QUrl url = m_cardMap[id]->m_image;
    QString source = url.toString();
    QFileInfo fileInfo(url.toLocalFile());
    if (fileInfo.isDir() | !fileInfo.exists())
        source = "qrc:/MemoPad/ui/assets/themes/lumos/image.svg";
    return source;
}

void CardManager::setImage(QString id, QUrl imageUrl)
{
    // get string path from url
    QString imageSource = imageUrl.toLocalFile();

    // clear the previous image
    QString previousImage = QCoreApplication::applicationDirPath() + "/save/images/" + m_IO->value(m_currentCanvasID + "/" + id + "/image").toString();
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
    m_cardMap[id]->m_image = "file:///" + imageTarget; // qml need URI to work
    m_IO->setValue(m_currentCanvasID + "/" + id + "/image", fileName);
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
    /*remove all sub-canvases that the id refers to recursively (in case this id belongs to a card of type "canvas")*/
    deleteCanvasByCanvasCard(id, m_currentCanvasID);

    /*remove it from memory*/
    m_cardMap.remove(id);

    /*remove this card from disk*/
    m_IO->beginGroup(m_currentCanvasID);
    m_IO->remove(id);
    m_IO->endGroup();
}

/// @brief a recursive function for deleting all sub-canvases by a canvas card id
void CardManager::deleteCanvasByCanvasCard(QString id, QString currentCanvasID)
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
        if (currentCanvasID == m_currentCanvasID & cardID != id)
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
