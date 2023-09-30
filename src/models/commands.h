#ifndef COMMANDS_H
#define COMMANDS_H

#include <QDebug>

#include "command.h"

class CommandMoveCard : public Command {
    Q_OBJECT
public:
    CommandMoveCard(QString id, qreal lastX, qreal lastY, qreal currentX, qreal currentY, QObject* parent = nullptr)
        : Command { id, parent }
    {
        m_id = id;
        m_lastX = lastX;
        m_lastY = lastY;
        m_currentX = currentX;
        m_currentY = currentY;
    };

    void undo() override
    {
        emit moveCardSignal(m_id, m_lastX, m_lastY);
    };
    void redo() override
    {
        emit moveCardSignal(m_id, m_currentX, m_currentY);
    };

signals:
    void moveCardSignal(QString id, qreal x, qreal y);

private:
    QString m_id;
    qreal m_lastX;
    qreal m_lastY;
    qreal m_currentX;
    qreal m_currentY;
};

class CommandResizeCard : public Command {
    Q_OBJECT
public:
    CommandResizeCard(QString id, qreal lastWidth, qreal lastHeight, qreal currentWidth, qreal currentHeight, QObject* parent = nullptr)
        : Command { id, parent }
    {
        m_id = id;
        m_lastWidth = lastWidth;
        m_lastHeight = lastHeight;
        m_currentWidth = currentWidth;
        m_currentHeight = currentHeight;
    };

    void undo() override
    {
        emit resizeCardSignal(m_id, m_lastWidth, m_lastHeight);
    };
    void redo() override
    {
        emit resizeCardSignal(m_id, m_currentWidth, m_currentHeight);
    };

signals:
    void resizeCardSignal(QString id, qreal width, qreal height);

private:
    QString m_id;
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
    CommandTransformCard(QString id, qreal lastX, qreal lastY, qreal currentX, qreal currentY, qreal lastWidth, qreal lastHeight, qreal currentWidth, qreal currentHeight, QObject* parent = nullptr)
        : Command { id, parent }
    {
        m_id = id;
        m_lastX = lastX;
        m_lastY = lastY;
        m_currentX = currentX;
        m_currentY = currentY;
        m_lastWidth = lastWidth;
        m_lastHeight = lastHeight;
        m_currentWidth = currentWidth;
        m_currentHeight = currentHeight;
    };

    void undo() override
    {
        emit transformCardSignal(m_id, m_lastX, m_lastY, m_lastWidth, m_lastHeight);
    };
    void redo() override
    {
        emit transformCardSignal(m_id, m_currentX, m_currentY, m_currentWidth, m_currentHeight);
    };

signals:
    void transformCardSignal(QString id, qreal x, qreal y, qreal width, qreal height);

private:
    QString m_id;
    qreal m_lastX;
    qreal m_lastY;
    qreal m_currentX;
    qreal m_currentY;
    qreal m_lastWidth;
    qreal m_lastHeight;
    qreal m_currentWidth;
    qreal m_currentHeight;
};

class CommandChangeText : public Command {
    Q_OBJECT
public:
    CommandChangeText(QString id, QString lastText, QString currentText, QObject* parent = nullptr)
        : Command { id, parent }
    {
        m_id = id;
        m_lastText = lastText;
        m_currentText = currentText;
    };

    void undo() override
    {
        emit changeTextSignal(m_id, m_lastText);
    };
    void redo() override
    {
        emit changeTextSignal(m_id, m_currentText);
    };

signals:
    void changeTextSignal(QString id, QString text);

private:
    QString m_id;
    QString m_lastText;
    QString m_currentText;
};

#endif // COMMANDS_H
