#ifndef CSHELL_SHELL_H
#define CSHELL_SHELL_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <unistd.h>
#include <limits.h>
#include <pwd.h>

#define INPUT_BUFFER_MAX 4096

#ifndef PATH_MAX
#define PATH_MAX 4096
#endif

#ifndef HOST_NAME_MAX
#define HOST_NAME_MAX 255
#endif

typedef struct {
    char startup_home_directory[PATH_MAX];
    char previous_working_directory[PATH_MAX];
    bool has_previous_working_directory;
    char last_foreground_command[256];
    int last_foreground_duration_seconds;
} ShellContext;

extern ShellContext shell_ctx;

#endif
