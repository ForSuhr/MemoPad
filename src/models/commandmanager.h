#ifndef COMMANDMANAGER_H
#define COMMANDMANAGER_H

#include <QObject>

#include <stack>

#include "command.h"

class CommandManager : public QObject {
    Q_OBJECT
public:
    explicit CommandManager(QObject* parent = nullptr);

    Q_INVOKABLE void execute(Command* command);
    Q_INVOKABLE void undo();
    Q_INVOKABLE void redo();

signals:

private:
    std::stack<Command*> m_undoStack;
    std::stack<Command*> m_redoStack;
};

#endif // COMMANDMANAGER_H
