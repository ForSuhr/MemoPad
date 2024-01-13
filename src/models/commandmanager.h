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
    Q_INVOKABLE void clearUndoStack();
    Q_INVOKABLE void clearRedoStack();

    /*commands*/
    Q_INVOKABLE void moveCard(QString cardID, qreal lastX, qreal lastY, qreal lastZ, qreal currentX, qreal currentY, qreal currentZ);
    Q_INVOKABLE void resizeCard(QString cardID, qreal lastWidth, qreal lastHeight, qreal currentWidth, qreal currentHeight);
    Q_INVOKABLE void transformCard(QString cardID, qreal lastX, qreal lastY, qreal lastZ, qreal currentX, qreal currentY, qreal currentZ, qreal lastWidth, qreal lastHeight, qreal currentWidth, qreal currentHeight);
    Q_INVOKABLE void changeText(QString cardID, QString lastText, QString currentText);
    Q_INVOKABLE void changeBackgroundColor(QString cardID, QString lastColor, QString currentColor);

signals:
    void moveCardSignal(QString cardID, qreal x, qreal y, qreal z);
    void resizeCardSignal(QString cardID, qreal width, qreal height);
    void transformCardSignal(QString cardID, qreal x, qreal y, qreal z, qreal width, qreal height);
    void changeTextSignal(QString cardID, QString text);
    void changeBackgroundColorSignal(QString cardID, QString color);

    void undoStackEmptySignal(bool isEmpty);
    void redoStackEmptySignal(bool isEmpty);

private:
    std::stack<Command*> m_undoStack;
    std::stack<Command*> m_redoStack;
};

#endif // COMMANDMANAGER_H
