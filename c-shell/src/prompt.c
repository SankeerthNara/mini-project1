#include "prompt.h"
#include "shell.h"
#include <limits.h>

#ifndef HOST_NAME_MAX
#define HOST_NAME_MAX 255
#endif

#ifndef PATH_MAX
#define PATH_MAX 4096
#endif

void prompt_init(void) {
  if (getcwd(sh_env.home_dir, sizeof(sh_env.home_dir)) == NULL) {
    perror("getcwd");
    exit(EXIT_FAILURE);
  }
}

void prompt_display(void) {
    // 1. fetch user info
    char *user = NULL;
    struct passwd *pw = getpwuid(getuid());
    if (pw && pw->pw_name) {
        user = pw->pw_name;
    } else {
        user = getenv("USER");
        if (!user) user = "user";
    }

  // 2. hostname
  char host[HOST_NAME_MAX + 1];
  if (gethostname(host, sizeof(host)) != 0) {
      strncpy(host, "unknown", sizeof(host) - 1);
      host[sizeof(host) - 1] = '\0';
  }

  // 3. cwd resolution
  char cwd[PATH_MAX];
  if (getcwd(cwd, sizeof(cwd)) == NULL) {
      strncpy(cwd, "?", sizeof(cwd));
  }

  // 4. path shortening with ~
  char display_path[PATH_MAX];
  size_t home_len = strlen(sh_env.home_dir);

  if (strcmp(cwd, sh_env.home_dir) == 0) {
      snprintf(display_path, sizeof(display_path), "~");
  } else if (strncmp(cwd, sh_env.home_dir, home_len) == 0 && (cwd[home_len] == '/' || home_len == 1)) {
    snprintf(display_path, sizeof(display_path), "~%s", cwd + home_len);
  } else {
      snprintf(display_path, sizeof(display_path), "%s", cwd);
  }

  printf("<%s@%s:%s> ", user, host, display_path);
  fflush(stdout);
}