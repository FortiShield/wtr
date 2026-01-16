# AI Tool Adapter Contract

- Must be placed in `adapters/ai/`.
- Function-based adapters implement:
  - `ai_can_start()`: Returns 0 if the tool is available.
  - `ai_start(path, [args...])`: Starts the tool in the specified worktree path.
- Script-based adapters implement:
  - Argument 1: `open` (the start command).
  - Argument 2: `path` (worktree directory).
  - Remaining args: Passed directly to the tool.
- Always `cd` into the worktree path before launching the tool.
