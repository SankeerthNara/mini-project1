#include "spy.h"

#include <dirent.h>
#include <errno.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

static int parsepid(const char *text, pid_t *pid)
{
    if (text == NULL || *text == '\0')
        return 0;

    long value = 0;

    for (const char *p = text; *p != '\0'; ++p)
    {
        if (*p < '0' || *p > '9')
            return 0;

        if (value > (LONG_MAX - (*p - '0')) / 10)
            return 0;

        value = value * 10 + (*p - '0');

        if (value > INT_MAX)
            return 0;
    }

    if (value <= 0)
        return 0;

    *pid = (pid_t)value;
    return 1;
}

static const char *filetype(const char *path)
{
    static char cleanpath[PATH_MAX];

    snprintf(cleanpath, sizeof(cleanpath), "%s", path);

    char *deleted = strstr(cleanpath, " (deleted)");
    if (deleted != NULL)
        *deleted = '\0';

    struct stat st;

    if (stat(cleanpath, &st) == -1)
{
    if (strncmp(cleanpath, "pipe:[", 6) == 0)
        return "FIFO";

    if (strncmp(cleanpath, "socket:[", 8) == 0)
        return "SOCK";

    /*
     * A deleted file can still be open by a process.
     * If stat() fails after "(deleted)" was removed,
     * treat an absolute path as a regular file.
     */
    if (cleanpath[0] == '/')
        return "REG";

    return "UNKNOWN";
}

    if (S_ISREG(st.st_mode))
        return "REG";
    if (S_ISDIR(st.st_mode))
        return "DIR";
    if (S_ISCHR(st.st_mode))
        return "CHR";
    if (S_ISBLK(st.st_mode))
        return "BLK";
    if (S_ISFIFO(st.st_mode))
        return "FIFO";
    if (S_ISSOCK(st.st_mode))
        return "SOCK";
    if (S_ISLNK(st.st_mode))
        return "LNK";

    return "UNKNOWN";
}

static void printentry(pid_t pid, const char *fd, const char *path)
{
    printf("%d    %-5s %-7s %s\n",
           (int)pid,
           fd,
           filetype(path),
           path);
}

static void printmemorymaps(pid_t pid)
{
    char mapsfile[64];
    snprintf(mapsfile, sizeof(mapsfile), "/proc/%d/maps", (int)pid);

    FILE *file = fopen(mapsfile, "r");
    if (file == NULL)
        return;

    char line[PATH_MAX + 512];

    char **seen = NULL;
    size_t seencount = 0;

    while (fgets(line, sizeof(line), file) != NULL)
    {
        char perms[8];
        unsigned long start;
        unsigned long end;
        unsigned long offset;
        unsigned int devmajor;
        unsigned int devminor;
        unsigned long inode;

        int used = sscanf(line,
                          "%lx-%lx %7s %lx %x:%x %lu",
                          &start,
                          &end,
                          perms,
                          &offset,
                          &devmajor,
                          &devminor,
                          &inode);

        if (used != 7)
            continue;

        char *path = strchr(line, '/');

        if (path == NULL)
            continue;

        path[strcspn(path, "\n")] = '\0';

        if (*path == '\0')
            continue;

        int duplicate = 0;

        for (size_t i = 0; i < seencount; ++i)
        {
            if (strcmp(seen[i], path) == 0)
            {
                duplicate = 1;
                break;
            }
        }

        if (duplicate)
            continue;

        if (seencount >= 4096)
            break;

        char *copy = malloc(strlen(path) + 1);
        if (copy == NULL)
            break;

        strcpy(copy, path);

        char **newseen = realloc(seen, (seencount + 1) * sizeof(char *));
        if (newseen == NULL)
        {
            free(copy);
            break;
        }

        seen = newseen;
        seen[seencount++] = copy;

        printentry(pid, "mem", path);
    }

    for (size_t i = 0; i < seencount; ++i)
        free(seen[i]);

    free(seen);
    fclose(file);
}

static void printfdentries(pid_t pid)
{
    char fdpath[64];
    snprintf(fdpath, sizeof(fdpath), "/proc/%d/fd", (int)pid);

    DIR *dir = opendir(fdpath);
    if (dir == NULL)
        return;

    struct dirent *entry;

    while ((entry = readdir(dir)) != NULL)
    {
        if (entry->d_name[0] == '.')
            continue;

        char *end;
        errno = 0;

        long fdnum = strtol(entry->d_name, &end, 10);

        if (errno != 0 || *end != '\0' || fdnum < 0)
            continue;

        char linkpath[PATH_MAX];
        char target[PATH_MAX];

        snprintf(linkpath,
                 sizeof(linkpath),
                 "/proc/%d/fd/%s",
                 (int)pid,
                 entry->d_name);

        ssize_t len = readlink(linkpath, target, sizeof(target) - 1);

        if (len == -1)
            continue;

        target[len] = '\0';

        char fdname[32];
        snprintf(fdname, sizeof(fdname), "%ld", fdnum);

        printentry(pid, fdname, target);
    }

    closedir(dir);
}

static void printprocessfiles(pid_t pid)
{
    char procpath[64];
    snprintf(procpath, sizeof(procpath), "/proc/%d", (int)pid);

    struct stat st;

    if (stat(procpath, &st) == -1)
        return;

    char linkpath[PATH_MAX];
    char target[PATH_MAX];

    snprintf(linkpath, sizeof(linkpath), "%s/cwd", procpath);

    ssize_t len = readlink(linkpath, target, sizeof(target) - 1);
    if (len != -1)
    {
        target[len] = '\0';
        printentry(pid, "cwd", target);
    }

    snprintf(linkpath, sizeof(linkpath), "%s/exe", procpath);

    len = readlink(linkpath, target, sizeof(target) - 1);
    if (len != -1)
    {
        target[len] = '\0';
        printentry(pid, "txt", target);
    }

    printmemorymaps(pid);
    printfdentries(pid);
}

int spy_builtin(const ParsedCommand *command)
{
    if (command == NULL ||
        command->arguments_count == 0 ||
        strcmp(command->arguments_list[0], "spy") != 0)
    {
        return 0;
    }

    if (command->arguments_count > 2)
    {
        printf("spy: invalid syntax\n");
        return 1;
    }

    pid_t pid;

    if (command->arguments_count == 1)
    {
        pid = getpid();
    }
    else
    {
        if (!parsepid(command->arguments_list[1], &pid))
        {
            printf("spy: no such process\n");
            return 1;
        }
    }

    char procpath[64];
    snprintf(procpath, sizeof(procpath), "/proc/%d", (int)pid);

    struct stat st;

    if (stat(procpath, &st) == -1)
    {
        printf("spy: no such process\n");
        return 1;
    }

    printf("PID    FD    TYPE    PATH\n");

    printprocessfiles(pid);

    return 1;
}
