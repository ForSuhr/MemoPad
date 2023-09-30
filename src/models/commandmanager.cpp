#include "commandmanager.h"

CommandManager::CommandManager(QObject* parent)
    : QObject { parent }
{
}

void CommandManager::execute(QString id)
{
    std::unique_ptr<CommandSavePosState> command = std::unique_ptr<CommandSavePosState>(new CommandSavePosState(id, 1, 2));
    m_undoStack.push(std::move(command));
    m_redoStack = std::stack<std::unique_ptr<Command>>(); // clear the redo stack
}

void CommandManager::undo()
{
    if (!m_undoStack.empty()) {
        std::unique_ptr<Command> lastCommand = std::move(m_undoStack.top());
        lastCommand->undo();
        m_undoStack.pop();
        m_redoStack.push(std::move(lastCommand));
    }
}

void CommandManager::redo()
{
    if (!m_redoStack.empty()) {
        std::unique_ptr<Command> lastCommand = std::move(m_redoStack.top());
        lastCommand->redo();
        m_redoStack.pop();
        m_undoStack.push(std::move(lastCommand));
    }
}
