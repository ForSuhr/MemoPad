#include "command.h"

Command::Command(Card* card)
{
    m_card = card;
}

void Command::execute()
{
}

void Command::undo()
{
}

void Command::redo()
{
}
