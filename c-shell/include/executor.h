#ifndef CSHELL_EXECUTOR_H
#define CSHELL_EXECUTOR_H

#include "parser.h"

void execute_command_group(const ParsedCommandGroup *command_group);

#endif
