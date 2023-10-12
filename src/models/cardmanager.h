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
    Q_INVOKABLE QString cardType(QString id);
    Q_INVOKABLE qreal x(QString id);
    Q_INVOKABLE void setX(QString id, qreal x);
    Q_INVOKABLE qreal y(QString id);
    Q_INVOKABLE void setY(QString id, qreal y);
    Q_INVOKABLE qreal z(QString id);
    Q_INVOKABLE void setZ(QString id, qreal z);
    Q_INVOKABLE QSizeF pos(QString id);
    Q_INVOKABLE void setPos(QString id, qreal x, qreal y, qreal z);
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
    Q_INVOKABLE QString image(QString id);
    Q_INVOKABLE void setImage(QString id, QUrl imageUrl);

    Q_INVOKABLE QString canvasID(QString id);
    Q_INVOKABLE void setCanvasID(QString id, QString canvasID);
    Q_INVOKABLE QString canvasName(QString id);
    Q_INVOKABLE void setCanvasName(QString id, QString canvasName);
    Q_INVOKABLE QString currentCanvasID();
    Q_INVOKABLE QString upperCanvasID();

    QMap<QString, Card*> m_cardMap = {};
    QMap<QString, Canvas*> m_canvasMap = {};

public slots:
    QString createCard(QString cardType);
    void deleteCard(QString id);
    void deleteCanvasByCanvasCard(QString id, QString currentCanvasID);
    void loadCards();

    QString createCanvas(QString id, QString canvasName);
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
