#ifndef COMMAND_H
#define COMMAND_H

#include <QObject>
#include <QString>

class Command : public QObject {
    Q_OBJECT
public:
    Command(QString id, QObject* parent = nullptr)
    {
        m_id = id;
    };

    virtual void undo() = 0;
    virtual void redo() = 0;

private:
    QString m_id;
};

#endif // COMMAND_H
