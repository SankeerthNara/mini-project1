#include "prompt.h"
#include "shell.h"
#include <limits.h>

#ifndef HOST_NAME_MAX
#define HOST_NAME_MAX 255
#endif

#ifndef PATH_MAX
#define PATH_MAX 4096
#endif

void initialize_shell_prompt(void) {
    if (getcwd(shell_ctx.startup_home_directory, sizeof(shell_ctx.startup_home_directory)) == NULL) {
        perror("getcwd");
        exit(EXIT_FAILURE);
    }
}

static void compute_prompt_display_path(const char *current_directory, 
                                        const char *home_directory, 
                                        char *output_buffer, 
                                        size_t buffer_size) {
    size_t home_len = strlen(home_directory);

    if (strcmp(current_directory, home_directory) == 0) {
        snprintf(output_buffer, buffer_size, "~");
    } else if (strncmp(current_directory, home_directory, home_len) == 0 && 
              (current_directory[home_len] == '/' || home_len == 1)) {
        snprintf(output_buffer, buffer_size, "~%s", current_directory + home_len);
    } else {
        snprintf(output_buffer, buffer_size, "%s", current_directory);
    }
}

void render_shell_prompt(void) {
    // 1. Get logged-in username
    char *username = NULL;
    struct passwd *user_password_entry = getpwuid(getuid());
    if (user_password_entry && user_password_entry->pw_name) {
        username = user_password_entry->pw_name;
    } else {
        username = getenv("USER");
        if (!username) {
            username = "user";
        }
    }

    // 2. Get system hostname
    char system_hostname[HOST_NAME_MAX + 1];
    if (gethostname(system_hostname, sizeof(system_hostname)) != 0) {
        strncpy(system_hostname, "unknown", sizeof(system_hostname) - 1);
        system_hostname[sizeof(system_hostname) - 1] = '\0';
    }

    // 3. Get current working directory
    char current_working_directory[PATH_MAX];
    if (getcwd(current_working_directory, sizeof(current_working_directory)) == NULL) {
        strncpy(current_working_directory, "?", sizeof(current_working_directory));
    }

    // 4. Format relative path with ~ replacement
    char formatted_path[PATH_MAX];
    compute_prompt_display_path(current_working_directory, 
                                shell_ctx.startup_home_directory, 
                                formatted_path, 
                                sizeof(formatted_path));

    printf("<%s@%s:%s> ", username, system_hostname, formatted_path);
    fflush(stdout);
}
