#ifndef CARDMANAGER_H
#define CARDMANAGER_H

#include <QCoreApplication>
#include <QDateTime>
#include <QDebug>
#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QMap>
#include <QObject>
#include <QSizeF>
#include <QUrl>
#include <QUuid>

#include "../utils/qsettingsjson.h"
#include "canvas.h"
#include "card.h"

class CardManager : public QObject {
    Q_OBJECT
public:
    explicit CardManager(QObject* parent = nullptr);
    ~CardManager();

    Q_INVOKABLE int cardNum();
    Q_INVOKABLE QStringList cardIDs();
    Q_INVOKABLE QString cardType(QString cardID);
    Q_INVOKABLE qreal x(QString cardID);
    Q_INVOKABLE void setX(QString cardID, qreal x);
    Q_INVOKABLE qreal y(QString cardID);
    Q_INVOKABLE void setY(QString cardID, qreal y);
    Q_INVOKABLE qreal z(QString cardID);
    Q_INVOKABLE void setZ(QString cardID, qreal z);
    Q_INVOKABLE QSizeF pos(QString cardID);
    Q_INVOKABLE void setPos(QString cardID, qreal x, qreal y, qreal z);
    Q_INVOKABLE qreal width(QString cardID);
    Q_INVOKABLE void setWidth(QString cardID, qreal width);
    Q_INVOKABLE qreal height(QString cardID);
    Q_INVOKABLE void setHeight(QString cardID, qreal height);
    Q_INVOKABLE QSizeF size(QString cardID);
    Q_INVOKABLE void setSize(QString cardID, qreal width, qreal height);
    Q_INVOKABLE QString backgroundColor(QString cardID);
    Q_INVOKABLE void setBackgroundColor(QString cardID, QString backgroundColor);
    Q_INVOKABLE QString text(QString cardID);
    Q_INVOKABLE void setText(QString cardID, QString text);
    Q_INVOKABLE QString image(QString cardID);
    Q_INVOKABLE void setImage(QString cardID, QUrl imageUrl);

    Q_INVOKABLE QString canvasID(QString cardID);
    Q_INVOKABLE void setCanvasID(QString cardID, QString canvasID);
    Q_INVOKABLE QString canvasName(QString cardID);
    Q_INVOKABLE void setCanvasName(QString cardID, QString canvasName);
    Q_INVOKABLE QString currentCanvasID();
    Q_INVOKABLE QString upperCanvasID();
    Q_INVOKABLE void setCanvasColor(QString canvasID, QString canvasColor);
    Q_INVOKABLE QString canvasColor(QString canvasID);
    Q_INVOKABLE void setCurrentCanvasColor(QString canvasColor);
    Q_INVOKABLE QString currentCanvasColor();

    Q_INVOKABLE QString fromCardID(QString cardID);
    Q_INVOKABLE void setFromCardID(QString cardID, QString fromCardID);
    Q_INVOKABLE QString fromCardDirection(QString cardID);
    Q_INVOKABLE void setFromCardDirection(QString cardID, QString fromCardDirection);
    Q_INVOKABLE QString toCardID(QString cardID);
    Q_INVOKABLE void setToCardID(QString cardID, QString toCardID);
    Q_INVOKABLE QString toCardDirection(QString cardID);
    Q_INVOKABLE void setToCardDirection(QString cardID, QString toCardDirection);
    Q_INVOKABLE qreal fromX(QString cardID);
    Q_INVOKABLE void setFromX(QString cardID, qreal fromX);
    Q_INVOKABLE qreal fromY(QString cardID);
    Q_INVOKABLE void setFromY(QString cardID, qreal fromY);
    Q_INVOKABLE qreal toX(QString cardID);
    Q_INVOKABLE void setToX(QString cardID, qreal toX);
    Q_INVOKABLE qreal toY(QString cardID);
    Q_INVOKABLE void setToY(QString cardID, qreal toY);
    Q_INVOKABLE qreal controlX(QString cardID);
    Q_INVOKABLE void setControlX(QString cardID, qreal controlX);
    Q_INVOKABLE qreal controlY(QString cardID);
    Q_INVOKABLE void setControlY(QString cardID, qreal controlY);

    QMap<QString, Card*> m_cardMap = {};
    QMap<QString, Canvas*> m_canvasMap = {};

public slots:
    QString createCard(QString cardType);
    void deleteCard(QString cardID);
    void deleteCanvasByCanvasCard(QString cardID, QString currentCanvasID);
    void loadCards();

    QString createCanvas(QString cardID, QString canvasName);
    void loadCanvas(QString canvasID);

signals:
    void currentCanvasIDChanged(QString canvasID);

private:
    QString uuid();

    QString m_currentCanvasID = "canvas 0";
    QString m_upperCanvasID;
    QSettings* m_IO = nullptr;
};

#endif // CARDMANAGER_H
