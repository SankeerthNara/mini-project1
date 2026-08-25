#include "prompt.h"
#include "shell.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <pwd.h>

void display_shell_prompt(void) {
    char hostname[256];
    if (gethostname(hostname, sizeof(hostname)) != 0) {
        strncpy(hostname, "unknown", sizeof(hostname) - 1);
        hostname[sizeof(hostname) - 1] = '\0';
    }

    struct passwd *pw = getpwuid(getuid());
    const char *username = pw ? pw->pw_name : "user";

    char cwd[PATH_MAX];
    if (getcwd(cwd, sizeof(cwd)) == NULL) {
        strncpy(cwd, "unknown", sizeof(cwd) - 1);
        cwd[sizeof(cwd) - 1] = '\0';
    }

    char relative_dir[PATH_MAX];
    size_t home_len = strlen(shell_ctx.startup_home_directory);

    if (strcmp(cwd, shell_ctx.startup_home_directory) == 0) {
        snprintf(relative_dir, sizeof(relative_dir), "~");
    } else if (strncmp(cwd, shell_ctx.startup_home_directory, home_len) == 0 &&
               cwd[home_len] == '/') {
        snprintf(relative_dir, sizeof(relative_dir), "~%s", cwd + home_len);
    } else {
        snprintf(relative_dir, sizeof(relative_dir), "%s", cwd);
    }

    if (shell_ctx.last_foreground_duration_seconds >= 2 &&
        strlen(shell_ctx.last_foreground_command) > 0) {
        printf("<%s@%s:%s %s : %ds> ", username, hostname, relative_dir,
               shell_ctx.last_foreground_command,
               shell_ctx.last_foreground_duration_seconds);
        shell_ctx.last_foreground_command[0] = '\0';
        shell_ctx.last_foreground_duration_seconds = 0;
    } else {
        printf("<%s@%s:%s> ", username, hostname, relative_dir);
    }
    fflush(stdout);
}
