#include "commandmanager.h"

CommandManager::CommandManager(QObject* parent)
    : QObject { parent }
{
}

void CommandManager::execute(Command* command)
{
    m_undoStack.push(command);
    m_redoStack = std::stack<Command*>(); // clear the redo stack

    emit undoStackEmptySignal(false);
    emit redoStackEmptySignal(true);
}

void CommandManager::undo()
{
    if (!m_undoStack.empty()) {
        Command* lastCommand = m_undoStack.top();
        lastCommand->undo();
        m_undoStack.pop();
        m_redoStack.push(lastCommand);
    }

    emit undoStackEmptySignal(m_undoStack.empty());
    emit redoStackEmptySignal(m_redoStack.empty());
}

void CommandManager::redo()
{
    if (!m_redoStack.empty()) {
        Command* lastCommand = m_redoStack.top();
        lastCommand->redo();
        m_redoStack.pop();
        m_undoStack.push(lastCommand);
    }

    emit undoStackEmptySignal(m_undoStack.empty());
    emit redoStackEmptySignal(m_redoStack.empty());
}

void CommandManager::clearUndoStack()
{
    m_undoStack = std::stack<Command*>();
    emit undoStackEmptySignal(m_undoStack.empty());
}

void CommandManager::clearRedoStack()
{
    m_redoStack = std::stack<Command*>();
    emit redoStackEmptySignal(m_redoStack.empty());
}

void CommandManager::moveCard(QString cardID, qreal lastX, qreal lastY, qreal lastZ, qreal currentX, qreal currentY, qreal currentZ)
{
    CommandMoveCard* command = new CommandMoveCard(cardID, lastX, lastY, lastZ, currentX, currentY, currentZ, this);
    execute(command);
    connect(command, &CommandMoveCard::moveCardSignal, this, &CommandManager::moveCardSignal);
}

void CommandManager::resizeCard(QString cardID, qreal lastWidth, qreal lastHeight, qreal currentWidth, qreal currentHeight)
{
    CommandResizeCard* command = new CommandResizeCard(cardID, lastWidth, lastHeight, currentWidth, currentHeight, this);
    execute(command);
    connect(command, &CommandResizeCard::resizeCardSignal, this, &CommandManager::resizeCardSignal);
}

void CommandManager::transformCard(QString cardID, qreal lastX, qreal lastY, qreal lastZ, qreal currentX, qreal currentY, qreal currentZ, qreal lastWidth, qreal lastHeight, qreal currentWidth, qreal currentHeight)
{
    CommandTransformCard* command = new CommandTransformCard(cardID, lastX, lastY, lastZ, currentX, currentY, currentZ, lastWidth, lastHeight, currentWidth, currentHeight, this);
    execute(command);
    connect(command, &CommandTransformCard::transformCardSignal, this, &CommandManager::transformCardSignal);
}

void CommandManager::changeText(QString cardID, QString lastText, QString currentText)
{

    CommandChangeText* command = new CommandChangeText(cardID, lastText, currentText, this);
    execute(command);
    connect(command, &CommandChangeText::changeTextSignal, this, &CommandManager::changeTextSignal);
}

void CommandManager::changeBackgroundColor(QString cardID, QString lastColor, QString currentColor)
{
    CommandChangeBackgroundColor* command = new CommandChangeBackgroundColor(cardID, lastColor, currentColor, this);
    execute(command);
    connect(command, &CommandChangeBackgroundColor::changeBackgroundColorSignal, this, &CommandManager::changeBackgroundColorSignal);
}
