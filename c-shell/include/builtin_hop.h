#ifndef CSHELL_BUILTIN_HOP_H
#define CSHELL_BUILTIN_HOP_H

#include "parser.h"

// Executes the 'hop' command with direct pathing and persistent frecency fallback
int execute_builtin_hop(const ParsedCommand *command);

#endif
