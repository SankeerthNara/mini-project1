#ifndef SHELL_H
#define SHELL_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <unistd.h>
#include <limits.h>
#include <pwd.h>

#define INP_LENMAX 4096

typedef struct {
  char home_dir[PATH_MAX];
} ShellEnv;

extern ShellEnv sh_env;

#endif