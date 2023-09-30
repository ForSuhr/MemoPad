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

    Q_INVOKABLE void execute(QString id);
    Q_INVOKABLE void undo();
    Q_INVOKABLE void redo();

    /*commands*/
    //    Q_INVOKABLE void savePosState(QString id, qreal x, qreal y);

signals:

private:
    std::stack<std::unique_ptr<Command>> m_undoStack;
    std::stack<std::unique_ptr<Command>> m_redoStack;
};

#endif // COMMANDMANAGER_H
