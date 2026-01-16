# Editor Adapter Contract

- Must be placed in `adapters/editor/`.
- Function-based adapters must implement:
  - `editor_can_open()`: Returns 0 if the editor is available in the environment.
  - `editor_open(path, [workspace])`: Opens the editor at the specified path.
- Script-based adapters must:
  - Support `open` as the first argument.
  - Accept `path` as the second argument.
  - Accept `workspace_path` as the third argument (optional).
