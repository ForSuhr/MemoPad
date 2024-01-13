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

#endif // COMMANDS_H
