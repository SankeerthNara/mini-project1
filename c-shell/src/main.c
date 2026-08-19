#include "shell.h"
#include "prompt.h"
#include <unistd.h>

ShellEnv sh_env;

int main(void) {
    prompt_init();

    // Test 1: Starting Directory (Should show ~)
    printf("1. Starting Directory:\nExpected: <username@hostname:~>\nActual:   ");
    prompt_display();
    printf("\n\n");

    // Test 2: Subdirectory inside Home (Should show ~/include)
    if (chdir("include") == 0) {
        printf("2. Inside Subdirectory (include):\nExpected: <username@hostname:~/include>\nActual:   ");
        prompt_display();
        printf("\n\n");
    }

    // Test 3: Outside Home Directory (Should show absolute /tmp)
    if (chdir("/tmp") == 0) {
        printf("3. Non-Descendant Directory (/tmp):\nExpected: <username@hostname:/tmp>\nActual:   ");
        prompt_display();
        printf("\n\n");
    }

    // Test 4: Root Directory (Should show /)
    if (chdir("/") == 0) {
        printf("4. Root Directory (/):\nExpected: <username@hostname:/>\nActual:   ");
        prompt_display();
        printf("\n\n");
    }

    // Test 5: Back to shell root (Should return to ~)
    if (chdir(sh_env.home_dir) == 0) {
        printf("5. Restored Shell Home:\nExpected: <username@hostname:~>\nActual:   ");
        prompt_display();
        printf("\n");
    }

    return 0;
}
