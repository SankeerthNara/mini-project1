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

typedef struct {
    char startup_home_directory[PATH_MAX];
} ShellContext;

extern ShellContext shell_ctx;PATH_MAX

#endif
