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

void CommandManager::resizeCard(QString id, qreal lastWidth, qreal lastHeight, qreal currentWidth, qreal currentHeight)
{
    CommandResizeCard* command = new CommandResizeCard(id, lastWidth, lastHeight, currentWidth, currentHeight, this);
    execute(command);
    connect(command, &CommandResizeCard::resizeCardSignal, this, &CommandManager::resizeCardSignal);
}

void CommandManager::transformCard(QString id, qreal lastX, qreal lastY, qreal currentX, qreal currentY, qreal lastWidth, qreal lastHeight, qreal currentWidth, qreal currentHeight)
{
    CommandTransformCard* command = new CommandTransformCard(id, lastX, lastY, currentX, currentY, lastWidth, lastHeight, currentWidth, currentHeight, this);
    execute(command);
    connect(command, &CommandTransformCard::transformCardSignal, this, &CommandManager::transformCardSignal);
}

void CommandManager::changeText(QString id, QString lastText, QString currentText)
{

    CommandChangeText* command = new CommandChangeText(id, lastText, currentText, this);
    execute(command);
    connect(command, &CommandChangeText::changeTextSignal, this, &CommandManager::changeTextSignal);
}

void CommandManager::changeBackgroundColor(QString id, QString lastColor, QString currentColor)
{
    CommandChangeBackgroundColor* command = new CommandChangeBackgroundColor(id, lastColor, currentColor, this);
    execute(command);
    connect(command, &CommandChangeBackgroundColor::changeBackgroundColorSignal, this, &CommandManager::changeBackgroundColorSignal);
}
