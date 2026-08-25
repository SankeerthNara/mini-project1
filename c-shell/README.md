# C Shell (cshell)

A custom UNIX shell written in C that follows POSIX standards. Cshell has custom built-in utilities, smart frecency-based directory navigation, advanced multi-file I/O redirection and multi-stage pipeline orchestration.

---

## Project Structure

c-shell/

├── include/

│   ├── builtin_hop.h        # hop declarations and frecency structures

│   ├── builtin_locate.h     # locate binary search declarations

│   ├── builtin_log.h        # log command tracking declarations

│   ├── builtin_peek.h       # peek line-numbering and reverse declarations

│   ├── builtin_reveal.h     # reveal directory traversal declarations

│   ├── executor.h           # Execution pipeline & redirection engine

│   ├── lexer.h              # Tokenizer & quote/escape handling

│   ├── parser.h             # AST grammar parser & redirection arrays

│   ├── prompt.h             # Interactive formatting

│   └── shell.h              # Global shell context state

├── src/

│   ├── builtin_hop.c        # Frecency database & directory navigation

│   ├── builtin_locate.c     # Path lookup in CWD & $PATH

│   ├── builtin_log.c        # History tracking & execution

│   ├── builtin_peek.c       # lseek-based backward chunking & line parsing

│   ├── builtin_reveal.c     # ASCII-sorted directory listing

│   ├── executor.c           # Execution, fork/exec, pipe routing, tee-relay

│   ├── lexer.c              # Lexical analyzer, quote stripper escape resolver

│   ├── main.c               # REPL loop, signal handling, process reaping

│   ├── parser.c             # Multi-redirection & pipeline parsing

│   └── prompt.c             # Dynamic prompt renderer

├── Makefile                 # Build automation with strict -Werror flags

└── README.md

---

## Core Specifications & Built-ins

### Part A: Interactive Shell & Prompt

* Dynamic Prompt: Shows <username@hostname:relative_path>. The starting root is shortened to ~. If any foreground command takes 2 seconds or more to run the time is added (like <username@hostname:~ sleep : 3s>).

* Lexer / Parser: Handles any amount of whitespace quotes (" '). Escape sequences (\n, \t, etc.).

* Process Management: Background processes started with. Run separately and are cleaned up when done using non-blocking waitpid(... WNOHANG).

---

### Part B: Built-in Commands

#### B1: hop (Frecency Directory Navigation)

* Syntax: hop ((~ |. |.. | Name)*)?

* Runs directory jumps in sequence for all given arguments.

* Persistent Frecency Engine:

* Keeps track of visits in ~/.cshell_frecency.

* Calculates a score using frequency and recency decay: Score = raw_score / (1.0 + 0.05 * age_in_hours).

* Uses frecency lookup if a directory name does not directly resolve from the Current Working Directory (CWD).

* Prefers folder names over parent folder substrings.

#### B2: reveal (Directory Inspection)

* Syntax: reveal (-(a|t)*)* (~ |. |.. | Name)?

* Shows directory contents sorted in ASCII order.

* Flags:

* -a: Shows hidden files (files that start with.).

* -t: Shows subdirectory contents after each directory name.

#### B3: peek (File Inspection)

* Syntax: peek (-(n|r)*)* filename*

*. Combines input from regular files or stdin.

* Flags:

* -n: Numbers -empty lines only.

* -r: Reverses line order. For files that can be seeked uses lseek to read in 4096-byte chunks without loading the whole file into memory.

#### B4: locate (Binary Discovery)

* Syntax: locate <command_name>

* Checks the Current Working Directory (CWD) first $PATH to see if an executable exists.

#### log (Command History)

* Syntax: log, log purge log execute <index>

* Saves up to 15 commands across sessions in ~/.cshell_log.

---

### Part C: Execution, Redirection & Pipelines

#### C1: Command Resolution

* %<command>: Skips. Checks $PATH directly.

* <path>/<binary>: Runs relative path targets.

* <command>: Checks CWD then $PATH.

#### C2: Multi-File Input Redirection (<)

* Allows multiple input sources (cmd < f1.txt < f2.txt).

* Checks files for readability. Feeds contents into STDIN_FILENO in order.

#### C3: Multi-File Output Redirection (> and >>)

* Lets you write to targets at the same time (cmd > out1.txt >> out2.txt).

* Uses a tee-relay child process to send data to all destination descriptors.

#### C4: Multi-Stage Pipelines (

* Allows any number of commands, in a chain (cmd1 cmd2 |... | CmdN).

* Sets up -process pipes with dup2() and manages descriptor closures.

---

## Build & Run

### Compilation

make clean. & Make all

### Execution

./shell.out

---

## Testing Workflow

# 1. Test frecency

hop include

hop src

hop ~

hop inc        # Jumps to include via frecency

# 2. Test reveal

reveal -at

# 3. Test peek chunked reverse & line numbers

peek -nr

printf "one\n\ntwo\n" | peek -nr

# 4. Test multi-redirection & piping

cat < src/main.c < src/executor.c | > combined_sorted.txt