#ifndef CSHELL_EXECUTOR_H
#define CSHELL_EXECUTOR_H

#include "parser.h"

void install_sigchld(void);
void install_shell_signal_handlers(void);
void initialize_terminal_control(void);
void reap_background_processes(void);
void execute_command_group(const ParsedCommandGroup *command_group);
bool has_stopped_jobs(void);
void hangup_all_jobs(void);

#endif
