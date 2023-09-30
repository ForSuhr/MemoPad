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
    Q_INVOKABLE void resizeCard(QString id, qreal lastWidth, qreal lastHeight, qreal currentWidth, qreal currentHeight);
    Q_INVOKABLE void transformCard(QString id, qreal lastX, qreal lastY, qreal currentX, qreal currentY, qreal lastWidth, qreal lastHeight, qreal currentWidth, qreal currentHeight);

signals:
    void moveCardSignal(QString id, qreal x, qreal y);
    void resizeCardSignal(QString id, qreal width, qreal height);
    void transformCardSignal(QString id, qreal x, qreal y, qreal width, qreal height);

private:
    std::stack<Command*> m_undoStack;
    std::stack<Command*> m_redoStack;
};

#endif // COMMANDMANAGER_H
