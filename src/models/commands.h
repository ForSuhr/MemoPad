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
        qInfo() << "undo: " << m_lastX << " , " << m_lastY;
        emit moveCardSignal(m_id, m_lastX, m_lastY);
    };
    void redo() override
    {
        qInfo() << "redo: " << m_currentX << " , " << m_currentY;
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

#endif // COMMANDS_H
