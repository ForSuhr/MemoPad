#include "commandmanager.h"

CommandManager::CommandManager(QObject* parent)
    : QObject { parent }
{
}

void CommandManager::execute(Command* command)
{
    m_undoStack.push(command);
    m_redoStack = std::stack<Command*>(); // clear the redo stack
}

void CommandManager::undo()
{
    if (!m_undoStack.empty()) {
        Command* lastCommand = m_undoStack.top();
        lastCommand->undo();
        m_undoStack.pop();
        m_redoStack.push(lastCommand);
    }
}

void CommandManager::redo()
{
    if (!m_redoStack.empty()) {
        Command* lastCommand = m_redoStack.top();
        lastCommand->redo();
        m_redoStack.pop();
        m_undoStack.push(lastCommand);
    }
}

void CommandManager::moveCard(QString id, qreal lastX, qreal lastY, qreal currentX, qreal currentY)
{
    CommandMoveCard* command = new CommandMoveCard(id, lastX, lastY, currentX, currentY, this);
    execute(command);
    connect(command, &CommandMoveCard::moveCardSignal, this, &CommandManager::moveCardSignal);
}
