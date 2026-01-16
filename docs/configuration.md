# Configuration Guide

BranchOps is highly configurable, allowing you to tailor the worktree management experience to your workflow. Settings can be managed at a system, user, or repository level.

## Configuration Precedence

BranchOps resolves configuration settings in the following order of priority (highest to lowest):

1.  **Repository Git Config** (`.git/config`): Specific to the current repository, managed via `git config --local`.
2.  **Shared Repository Config** (`.branchopsconfig`): Team-shared settings checked into the repository root.
3.  **User Global Git Config** (`~/.gitconfig`): Global settings for all repositories, managed via `git config --global`.
4.  **System Git Config** (`/etc/gitconfig`): System-wide settings for all users.
5.  **Environment Variables**: Temporary overrides via the shell environment.
6.  **Default Values**: Built-in fallback values.

## The `.branchopsconfig` File

The `.branchopsconfig` file allows teams to share common settings (like build artifacts to copy or post-creation hooks) across all developers working on a project.

This file uses the standard `git-config` syntax. Example:

```ini
[copy]
    include = .env.example
    include = config.sample.json
    includeDirs = node_modules
    includeDirs = .venv
    excludeDirs = node_modules/.cache

[hooks]
    postCreate = npm install
    postCreate = direnv allow

[defaults]
    editor = cursor
    ai = claude
```

> [!NOTE]
> The `.branchopsconfig` file supports a simplified key structure compared to Git configuration. See the [Mapping Table](#mapping-table) below for details.

## Configuration Options

### Path Settings

| Git Config Key | Default | Description |
| :--- | :--- | :--- |
| `branchops.worktrees.dir` | `../<repo>-worktrees` | The base directory where worktrees are created. Relative paths are resolved from the repository root. |
| `branchops.worktrees.prefix` | `""` | A prefix added to every worktree folder name. |

### Behavior Settings

| Git Config Key | Default | Description |
| :--- | :--- | :--- |
| `branchops.defaultBranch` | `auto` | The base branch used when creating new worktrees without `--from`. Auto-detects `main` or `master`. |

### Tool Defaults

| Git Config Key | .branchopsconfig Key | Description |
| :--- | :--- | :--- |
| `branchops.editor.default` | `defaults.editor` | Default editor adapter to use for `new -e` or `editor` commands. |
| `branchops.editor.workspace` | `editor.workspace` | Path to a `.code-workspace` file (relative to worktree root). Auto-detects if not set. |
| `branchops.ai.default` | `defaults.ai` | Default AI tool adapter to use for `new -a` or `ai` commands. |

### Copy Patterns (Multi-valued)

These settings determine which files and directories are copied from the main repository when a new worktree is created.

| Git Config Key | .branchopsconfig Key | Description |
| :--- | :--- | :--- |
| `branchops.copy.include` | `copy.include` | Glob patterns for files to copy (e.g., `.env.example`). |
| `branchops.copy.exclude` | `copy.exclude` | Glob patterns for files to explicitly skip. |
| `branchops.copy.includeDirs` | `copy.includeDirs` | Names of directories to copy (e.g., `node_modules`, `vendor`). |
| `branchops.copy.excludeDirs` | `copy.excludeDirs` | Glob patterns for subdirectories to skip within included directories (e.g., `node_modules/.cache`). |

### Hooks (Multi-valued)

Commands to run automatically at various stages of the worktree lifecycle.

| Git Config Key | .branchopsconfig Key | Description |
| :--- | :--- | :--- |
| `branchops.hook.postCreate` | `hooks.postCreate` | Runs after a worktree is created and files are copied. |
| `branchops.hook.preRemove` | `hooks.preRemove` | Runs before a worktree is removed. Aborts removal if the hook fails (returns non-zero). |
| `branchops.hook.postRemove` | `hooks.postRemove` | Runs after a worktree has been successfully removed. |

## Multi-valued Configurations

For settings that support multiple values (like copy patterns and hooks), you can add values in Git configuration using the `--add` flag:

```bash
git config --add branchops.copy.include ".env.local"
git config --add branchops.hook.postCreate "pnpm install"
```

In `.branchopsconfig`, simply repeat the key:

```ini
[copy]
    include = .env.local
    include = .npmrc
```

## Management Commands

Use the `git branchops config` command to manage settings without editing files manually.

```bash
# List all current settings (merged)
git branchops config list

# Get a specific value
git branchops config get branchops.editor.default

# Set a value for the current repository
git branchops config set branchops.editor.default cursor --local

# Set a value globally for all repositories
git branchops config set branchops.ai.default claude --global

# Remove a setting
git branchops config unset branchops.worktrees.prefix
```

## Environment Variables

For temporary overrides or CI/CD pipelines, you can use environment variables:

- `BRANCHOPS_WORKTREES_DIR`: Overrides the base directory for worktrees.
- `BRANCHOPS_WORKTREES_PREFIX`: Overrides the folder prefix.
- `BRANCHOPS_EDITOR_DEFAULT`: Overrides the default editor.
- `BRANCHOPS_AI_DEFAULT`: Overrides the default AI tool.
- `BRANCHOPS_LOG_FILE`: Path to a file for logging CLI operations.
- `BRANCHOPS_DEBUG`: Set to `1` to enable detailed debug output.
