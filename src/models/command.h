#ifndef COMMAND_H
#define COMMAND_H

#include <QString>

enum CommandType {
    SavePosState
};

class Command {
public:
    Command(QString id);

    virtual void execute() = 0;
    virtual void undo() = 0;
    virtual void redo() = 0;

private:
    QString m_id;
    //    CommandType m_commandType;
};

#endif // COMMAND_H
