#ifndef CARDMANAGER_H
#define CARDMANAGER_H

#include <QCoreApplication>
#include <QDebug>
#include <QMap>
#include <QObject>
#include <QSizeF>
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
    Q_INVOKABLE QString cardType(QString id);
    Q_INVOKABLE qreal x(QString id);
    Q_INVOKABLE void setX(QString id, qreal x);
    Q_INVOKABLE qreal y(QString id);
    Q_INVOKABLE void setY(QString id, qreal y);
    Q_INVOKABLE QSizeF pos(QString id);
    Q_INVOKABLE void setPos(QString id, qreal x, qreal y);
    Q_INVOKABLE qreal width(QString id);
    Q_INVOKABLE void setWidth(QString id, qreal width);
    Q_INVOKABLE qreal height(QString id);
    Q_INVOKABLE void setHeight(QString id, qreal height);
    Q_INVOKABLE QSizeF size(QString id);
    Q_INVOKABLE void setSize(QString id, qreal width, qreal height);
    Q_INVOKABLE QString backgroundColor(QString id);
    Q_INVOKABLE void setBackgroundColor(QString id, QString backgroundColor);
    Q_INVOKABLE QString text(QString id);
    Q_INVOKABLE void setText(QString id, QString text);

    Q_INVOKABLE QString canvasID(QString id);
    Q_INVOKABLE void setCanvasID(QString id, QString canvasID);
    Q_INVOKABLE QString canvasName(QString id);
    Q_INVOKABLE void setCanvasName(QString id, QString canvasName);

    QMap<QString, Card*> m_cardMap = {};
    QMap<QString, Canvas*> m_canvasMap = {};

public slots:
    QString createCard(QString cardType);
    void deleteCard(QString id);
    void loadCards();

    QString createCanvas(QString id, QString canvasName);
    void loadCanvas(QString canvasID);

private:
    QString uuid();

    QString m_currentCanvasID = "canvas 0";
    QSettings* m_IO = nullptr;
};

#endif // CARDMANAGER_H
