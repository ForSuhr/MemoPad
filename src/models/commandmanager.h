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
    Q_INVOKABLE void changeFromCard(QString cardID, QString lastFromCardID, QString lastFromDirection, qreal lastFromX, qreal lastFromY, QString currentFromCardID, QString currentFromDirection, qreal currentFromX, qreal currentFromY);
    Q_INVOKABLE void changeToCard(QString cardID, QString lastToCardID, QString lastToDirection, qreal lastToX, qreal lastToY, QString currentToCardID, QString currentToDirection, qreal currentToX, qreal currentToY);
    Q_INVOKABLE void changeArrowPos(QString cardID, qreal lastFromX, qreal lastFromY, qreal lastToX, qreal lastToY, qreal lastControlX, qreal lastControlY, qreal currentFromX, qreal currentFromY, qreal currentToX, qreal currentToY, qreal currentControlX, qreal currentControlY);

signals:
    void moveCardSignal(QString cardID, qreal x, qreal y, qreal z);
    void resizeCardSignal(QString cardID, qreal width, qreal height);
    void transformCardSignal(QString cardID, qreal x, qreal y, qreal z, qreal width, qreal height);
    void changeTextSignal(QString cardID, QString text);
    void changeBackgroundColorSignal(QString cardID, QString color);
    void changeFromCardSignal(QString cardID, QString fromCardID, QString fromDirection, qreal fromX, qreal fromY);
    void changeToCardSignal(QString cardID, QString toCardID, QString toDirection, qreal toX, qreal toY);
    void changeArrowPosSignal(QString cardID, qreal fromX, qreal fromY, qreal toX, qreal toY, qreal controlX, qreal controlY);

    void undoStackEmptySignal(bool isEmpty);
    void redoStackEmptySignal(bool isEmpty);

private:
    std::stack<Command*> m_undoStack;
    std::stack<Command*> m_redoStack;
};

#endif // COMMANDMANAGER_H
