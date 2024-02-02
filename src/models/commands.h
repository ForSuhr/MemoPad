#ifndef COMMANDS_H
#define COMMANDS_H

#include <QDebug>

#include "command.h"

class CommandMoveCard : public Command {
    Q_OBJECT
public:
    CommandMoveCard(QString cardID, qreal lastX, qreal lastY, qreal lastZ, qreal currentX, qreal currentY, qreal currentZ, QObject* parent = nullptr)
        : Command { cardID, parent }
    {
        m_cardID = cardID;
        m_lastX = lastX;
        m_lastY = lastY;
        m_lastZ = lastZ;
        m_currentX = currentX;
        m_currentY = currentY;
        m_currentZ = currentZ;
    };

    void undo() override
    {
        emit moveCardSignal(m_cardID, m_lastX, m_lastY, m_lastZ);
    };
    void redo() override
    {
        emit moveCardSignal(m_cardID, m_currentX, m_currentY, m_currentZ);
    };

signals:
    void moveCardSignal(QString cardID, qreal x, qreal y, qreal z);

private:
    QString m_cardID;
    qreal m_lastX;
    qreal m_lastY;
    qreal m_lastZ;
    qreal m_currentX;
    qreal m_currentY;
    qreal m_currentZ;
};

class CommandResizeCard : public Command {
    Q_OBJECT
public:
    CommandResizeCard(QString cardID, qreal lastWidth, qreal lastHeight, qreal currentWidth, qreal currentHeight, QObject* parent = nullptr)
        : Command { cardID, parent }
    {
        m_cardID = cardID;
        m_lastWidth = lastWidth;
        m_lastHeight = lastHeight;
        m_currentWidth = currentWidth;
        m_currentHeight = currentHeight;
    };

    void undo() override
    {
        emit resizeCardSignal(m_cardID, m_lastWidth, m_lastHeight);
    };
    void redo() override
    {
        emit resizeCardSignal(m_cardID, m_currentWidth, m_currentHeight);
    };

signals:
    void resizeCardSignal(QString cardID, qreal width, qreal height);

private:
    QString m_cardID;
    qreal m_lastX;
    qreal m_lastY;
    qreal m_currentX;
    qreal m_currentY;
    qreal m_lastWidth;
    qreal m_lastHeight;
    qreal m_currentWidth;
    qreal m_currentHeight;
};

class CommandTransformCard : public Command {
    Q_OBJECT
public:
    CommandTransformCard(QString cardID, qreal lastX, qreal lastY, qreal lastZ, qreal currentX, qreal currentY, qreal currentZ, qreal lastWidth, qreal lastHeight, qreal currentWidth, qreal currentHeight, QObject* parent = nullptr)
        : Command { cardID, parent }
    {
        m_cardID = cardID;
        m_lastX = lastX;
        m_lastY = lastY;
        m_lastZ = lastZ;
        m_currentX = currentX;
        m_currentY = currentY;
        m_currentZ = currentZ;
        m_lastWidth = lastWidth;
        m_lastHeight = lastHeight;
        m_currentWidth = currentWidth;
        m_currentHeight = currentHeight;
    };

    void undo() override
    {
        emit transformCardSignal(m_cardID, m_lastX, m_lastY, m_lastZ, m_lastWidth, m_lastHeight);
    };
    void redo() override
    {
        emit transformCardSignal(m_cardID, m_currentX, m_currentY, m_currentZ, m_currentWidth, m_currentHeight);
    };

signals:
    void transformCardSignal(QString cardID, qreal x, qreal y, qreal z, qreal width, qreal height);

private:
    QString m_cardID;
    qreal m_lastX;
    qreal m_lastY;
    qreal m_lastZ;
    qreal m_currentX;
    qreal m_currentY;
    qreal m_currentZ;
    qreal m_lastWidth;
    qreal m_lastHeight;
    qreal m_currentWidth;
    qreal m_currentHeight;
};

class CommandChangeText : public Command {
    Q_OBJECT
public:
    CommandChangeText(QString cardID, QString lastText, QString currentText, QObject* parent = nullptr)
        : Command { cardID, parent }
    {
        m_cardID = cardID;
        m_lastText = lastText;
        m_currentText = currentText;
    };

    void undo() override
    {
        emit changeTextSignal(m_cardID, m_lastText);
    };
    void redo() override
    {
        emit changeTextSignal(m_cardID, m_currentText);
    };

signals:
    void changeTextSignal(QString cardID, QString text);

private:
    QString m_cardID;
    QString m_lastText;
    QString m_currentText;
};

class CommandChangeBackgroundColor : public Command {
    Q_OBJECT
public:
    CommandChangeBackgroundColor(QString cardID, QString lastColor, QString currentColor, QObject* parent = nullptr)
        : Command { cardID, parent }
    {
        m_cardID = cardID;
        m_lastColor = lastColor;
        m_currentColor = currentColor;
    };

    void undo() override
    {
        emit changeBackgroundColorSignal(m_cardID, m_lastColor);
    };
    void redo() override
    {
        emit changeBackgroundColorSignal(m_cardID, m_currentColor);
    };

signals:
    void changeBackgroundColorSignal(QString cardID, QString color);

private:
    QString m_cardID;
    QString m_lastColor;
    QString m_currentColor;
};

class CommandChangeFromCard : public Command {
    Q_OBJECT
public:
    CommandChangeFromCard(QString cardID, QString lastFromCardID, QString lastFromDirection, qreal lastFromX, qreal lastFromY, QString currentFromCardID, QString currentFromDirection, qreal currentFromX, qreal currentFromY, QObject* parent = nullptr)
        : Command { cardID, parent }
    {
        m_cardID = cardID;
        m_lastFromCardID = lastFromCardID;
        m_lastFromDirection = lastFromDirection;
        m_currentFromCardID = currentFromCardID;
        m_currentFromDirection = currentFromDirection;
        m_lastFromX = lastFromX;
        m_lastFromY = lastFromY;
        m_currentFromX = currentFromX;
        m_currentFromY = currentFromY;
    };

    void undo() override
    {
        emit changeFromCardSignal(m_cardID, m_lastFromCardID, m_lastFromDirection, m_lastFromX, m_lastFromY);
    };
    void redo() override
    {
        emit changeFromCardSignal(m_cardID, m_currentFromCardID, m_currentFromDirection, m_currentFromX, m_currentFromY);
    };

signals:
    void changeFromCardSignal(QString cardID, QString fromCardID, QString fromDirection, qreal fromX, qreal fromY);

private:
    QString m_cardID;
    QString m_lastFromCardID;
    QString m_lastFromDirection;
    QString m_currentFromCardID;
    QString m_currentFromDirection;
    qreal m_lastFromX;
    qreal m_lastFromY;
    qreal m_currentFromX;
    qreal m_currentFromY;
};

class CommandChangeToCard : public Command {
    Q_OBJECT
public:
    CommandChangeToCard(QString cardID, QString lastToCardID, QString lastToDirection, qreal lastToX, qreal lastToY, QString currentToCardID, QString currentToDirection, qreal currentToX, qreal currentToY, QObject* parent = nullptr)
        : Command { cardID, parent }
    {
        m_cardID = cardID;
        m_lastToCardID = lastToCardID;
        m_lastToDirection = lastToDirection;
        m_currentToCardID = currentToCardID;
        m_currentToDirection = currentToDirection;
        m_lastToX = lastToX;
        m_lastToY = lastToY;
        m_currentToX = currentToX;
        m_currentToY = currentToY;
    };

    void undo() override
    {
        emit changeToCardSignal(m_cardID, m_lastToCardID, m_lastToDirection, m_lastToX, m_lastToY);
    };
    void redo() override
    {
        emit changeToCardSignal(m_cardID, m_currentToCardID, m_currentToDirection, m_currentToX, m_currentToY);
    };

signals:
    void changeToCardSignal(QString cardID, QString lastToCardID, QString lastToDirection, qreal toX, qreal toY);

private:
    QString m_cardID;
    QString m_lastToCardID;
    QString m_lastToDirection;
    QString m_currentToCardID;
    QString m_currentToDirection;
    qreal m_lastToX;
    qreal m_lastToY;
    qreal m_currentToX;
    qreal m_currentToY;
};

class CommandChangeArrowPos : public Command {
    Q_OBJECT
public:
    CommandChangeArrowPos(QString cardID, qreal lastFromX, qreal lastFromY, qreal lastToX, qreal lastToY, qreal lastControlX, qreal lastControlY, qreal currentFromX, qreal currentFromY, qreal currentToX, qreal currentToY, qreal currentControlX, qreal currentControlY, QObject* parent = nullptr)
        : Command { cardID, parent }
    {
        m_cardID = cardID;
        m_lastFromX = lastFromX;
        m_lastFromY = lastFromY;
        m_lastToX = lastToX;
        m_lastToY = lastToY;
        m_lastControlX = lastControlX;
        m_lastControlY = lastControlY;
        m_currentFromX = currentFromX;
        m_currentFromY = currentFromY;
        m_currentToX = currentToX;
        m_currentToY = currentToY;
        m_currentControlX = currentControlX;
        m_currentControlY = currentControlY;
    };

    void undo() override
    {
        emit changeArrowPosSignal(m_cardID, m_lastFromX, m_lastFromY, m_lastToX, m_lastToY, m_lastControlX, m_lastControlY);
    };
    void redo() override
    {
        emit changeArrowPosSignal(m_cardID, m_currentFromX, m_currentFromY, m_currentToX, m_currentToY, m_currentControlX, m_currentControlY);
    };

signals:
    void changeArrowPosSignal(QString cardID, qreal fromX, qreal fromY, qreal toX, qreal toY, qreal controlX, qreal controlY);

private:
    QString m_cardID;
    qreal m_lastFromX;
    qreal m_lastFromY;
    qreal m_lastToX;
    qreal m_lastToY;
    qreal m_lastControlX;
    qreal m_lastControlY;
    qreal m_currentFromX;
    qreal m_currentFromY;
    qreal m_currentToX;
    qreal m_currentToY;
    qreal m_currentControlX;
    qreal m_currentControlY;
};

#endif // COMMANDS_H
