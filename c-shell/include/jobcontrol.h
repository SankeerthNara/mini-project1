#ifndef CSHELL_JOBCONTROL_H
#define CSHELL_JOBCONTROL_H

#include "parser.h"
#include <sys/types.h>

void install_sigchld(void);
void install_shell_signal_handlers(void);
void initialize_terminal_control(void);
void give_terminal_to(pid_t pgid);
void reclaim_terminal(void);
void reap_background_processes(void);
void remember_background(pid_t pgid, const pid_t *pids,
                         const CommandPipeline *pipeline);
void remember_stopped_foreground(pid_t pgid, const pid_t *pids,
                                  const CommandPipeline *pipeline);
int activity_builtin(const ParsedCommand *command);
int resume_builtin(const ParsedCommand *command);
int ping_builtin(const ParsedCommand *command);
unsigned long latest_job_number(void);
bool has_stopped_jobs(void);
void hangup_all_jobs(void);

#endif
