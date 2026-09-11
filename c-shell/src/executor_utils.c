#include "executor_utils.h"
#include "builtin_hop.h"
#include "builtin_reveal.h"
#include "builtin_peek.h"
#include "builtin_locate.h"
#include "builtin_log.h"

#include <sys/stat.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <limits.h>

static bool executable(const char *path)
{
    struct stat st;
    return stat(path, &st) == 0 && S_ISREG(st.st_mode) &&
           access(path, X_OK) == 0;
}

bool is_builtin_command(const char *name)
{
    return name && (!strcmp(name, "hop") || !strcmp(name, "reveal") ||
                    !strcmp(name, "peek") || !strcmp(name, "locate") ||
                    !strcmp(name, "log") || !strcmp(name, "activities"));
}

int run_builtin_command(const ParsedCommand *command)
{
    const char *name = command->arguments_list[0];
    if (!strcmp(name, "hop")) return execute_builtin_hop(command);
    if (!strcmp(name, "reveal")) return execute_builtin_reveal(command);
    if (!strcmp(name, "peek")) return execute_builtin_peek(command);
    if (!strcmp(name, "locate")) return execute_builtin_locate(command);
    if (!strcmp(name, "log")) return execute_builtin_log(command);
    return 0;
}

char *resolve_binary(const char *name)
{
    if (!name || !*name) return NULL;

    const char *lookup = name;
    if (*name == '%') lookup = name + 1;

    if (*name != '%' && strchr(name, '/'))
        return executable(name) ? strdup(name) : NULL;

    if (*name != '%') {
        char path[PATH_MAX];
        if (snprintf(path, sizeof(path), "./%s", name) < (int)sizeof(path) &&
            executable(path))
            return strdup(path);
    }

    char *path_env = getenv("PATH");
    if (!path_env) return NULL;

    char *copy = strdup(path_env);
    if (!copy) return NULL;

    char *save = NULL;
    for (char *dir = strtok_r(copy, ":", &save); dir;
         dir = strtok_r(NULL, ":", &save)) {
        char path[PATH_MAX];
        const char *base = *dir ? dir : ".";
        if (snprintf(path, sizeof(path), "%s/%s", base, lookup) <
                (int)sizeof(path) &&
            executable(path)) {
            char *result = strdup(path);
            free(copy);
            return result;
        }
    }

    free(copy);
    return NULL;
}
