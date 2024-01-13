#ifndef COMMAND_H
#define COMMAND_H

#include <QObject>
#include <QString>

class Command : public QObject {
    Q_OBJECT
public:
    Command(QString cardID, QObject* parent = nullptr)
    {
        m_cardID = cardID;
    };

    virtual void undo() = 0;
    virtual void redo() = 0;

private:
    QString m_cardID;
};

#endif // COMMAND_H
