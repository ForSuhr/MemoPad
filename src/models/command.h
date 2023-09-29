#ifndef COMMAND_H
#define COMMAND_H

#include "card.h"

class Command {
public:
    Command(Card* card);

    void execute();
    void undo();
    void redo();
};

#endif // COMMAND_H
