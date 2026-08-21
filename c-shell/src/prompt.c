#include "prompt.h"
#include "shell.h"

void initialize_shell_prompt(void) {
    if (getcwd(shell_ctx.startup_home_directory, sizeof(shell_ctx.startup_home_directory)) == NULL) {
        perror("getcwd");
        exit(EXIT_FAILURE);
    }
    shell_ctx.has_previous_working_directory = false;
    shell_ctx.previous_working_directory[0] = '\0';
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
    char *username = NULL;
    struct passwd *user_password_entry = getpwuid(getuid());
    if (user_password_entry && user_password_entry->pw_name) {
        username = user_password_entry->pw_name;
    } else {
        username = getenv("USER");
        if (!username) username = "user";
    }

    char system_hostname[HOST_NAME_MAX + 1];
    if (gethostname(system_hostname, sizeof(system_hostname)) != 0) {
        strncpy(system_hostname, "unknown", sizeof(system_hostname) - 1);
        system_hostname[sizeof(system_hostname) - 1] = '\0';
    }

    char current_working_directory[PATH_MAX];
    if (getcwd(current_working_directory, sizeof(current_working_directory)) == NULL) {
        strncpy(current_working_directory, "?", sizeof(current_working_directory));
    }

    char formatted_path[PATH_MAX];
    compute_prompt_display_path(current_working_directory, 
                                shell_ctx.startup_home_directory, 
                                formatted_path, 
                                sizeof(formatted_path));

    printf("<%s@%s:%s> ", username, system_hostname, formatted_path);
    fflush(stdout);
}
