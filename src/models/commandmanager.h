#ifndef COMMANDMANAGER_H
#define COMMANDMANAGER_H

#include <QObject>

#include <memory>
#include <stack>

#include "commands.h"

class CommandManager : public QObject {
    Q_OBJECT
public:
    explicit CommandManager(QObject* parent = nullptr);

    Q_INVOKABLE void execute(Command* command);
    Q_INVOKABLE void undo();
    Q_INVOKABLE void redo();

    /*commands*/
    Q_INVOKABLE void moveCard(QString id, qreal lastX, qreal lastY, qreal currentX, qreal currentY);

signals:
    void moveCardSignal(QString id, qreal x, qreal y);

private:
    std::stack<Command*> m_undoStack;
    std::stack<Command*> m_redoStack;
};

#endif // COMMANDMANAGER_H
