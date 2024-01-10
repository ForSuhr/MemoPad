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
    Q_INVOKABLE void moveCard(QString id, qreal lastX, qreal lastY, qreal lastZ, qreal currentX, qreal currentY, qreal currentZ);
    Q_INVOKABLE void resizeCard(QString id, qreal lastWidth, qreal lastHeight, qreal currentWidth, qreal currentHeight);
    Q_INVOKABLE void transformCard(QString id, qreal lastX, qreal lastY, qreal lastZ, qreal currentX, qreal currentY, qreal currentZ, qreal lastWidth, qreal lastHeight, qreal currentWidth, qreal currentHeight);
    Q_INVOKABLE void changeText(QString id, QString lastText, QString currentText);
    Q_INVOKABLE void changeBackgroundColor(QString id, QString lastColor, QString currentColor);

signals:
    void moveCardSignal(QString id, qreal x, qreal y, qreal z);
    void resizeCardSignal(QString id, qreal width, qreal height);
    void transformCardSignal(QString id, qreal x, qreal y, qreal z, qreal width, qreal height);
    void changeTextSignal(QString id, QString text);
    void changeBackgroundColorSignal(QString id, QString color);

    void undoStackEmptySignal(bool isEmpty);
    void redoStackEmptySignal(bool isEmpty);

private:
    std::stack<Command*> m_undoStack;
    std::stack<Command*> m_redoStack;
};

#endif // COMMANDMANAGER_H
