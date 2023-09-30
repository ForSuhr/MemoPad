#ifndef COMMANDS_H
#define COMMANDS_H

#include "command.h"

class CommandSavePosState : public Command {

public:
    CommandSavePosState(QString id, qreal x, qreal y)
        : Command { id }
    {
        m_x = x;
        m_y = y;
    };

    void execute() override {};
    void undo() override {};
    void redo() override {};

private:
    qreal m_x;
    qreal m_y;
};

#endif // COMMANDS_H
