# Shell Completion Guidelines

- When adding a new command or flag, update ALL three:
  - `completions/branchops.bash`
  - `completions/_git-branchops` (Zsh)
  - `completions/git-branchops.fish`
- Command completion should dynamically list available branches and worktree IDs.
- Follow the existing formatting and structure for each shell's completion engine.
