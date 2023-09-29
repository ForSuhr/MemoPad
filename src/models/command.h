#ifndef COMMAND_H
#define COMMAND_H

#include "card.h"

class Command {
public:
    Command(Card* card);

    void execute();
    void undo();
    void redo();

private:
    Card* m_card = nullptr;
};

#endif // COMMAND_H
