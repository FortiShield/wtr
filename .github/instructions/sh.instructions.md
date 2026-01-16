# Shell Scripting Instructions

- Target Bash 3.2+ for macOS compatibility.
- Use `set -e` for error handling.
- Use `local` for all variables inside functions.
- Quote all variables: `"$var"`.
- Use `snake_case` for functions and variables.
- Prefer `[[ ]]` over `[ ]` if Bash-specific features are needed, but stick to `[ ]` for POSIX portability where possible.
- Use `log_info`, `log_error`, `log_step` from `lib/ui.sh` for all output.
