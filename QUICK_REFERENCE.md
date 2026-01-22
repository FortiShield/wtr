# WTR Architecture Quick Reference

## Directory Structure

```
wtr/
├── bin/
│   └── wtr                    # Entry point (simplified, uses dispatch)
│
├── lib/
│   ├── core.sh                # Dispatch system & routing
│   ├── commands/              # NEW: Modular command implementations
│   │   ├── add.sh
│   │   ├── remove.sh
│   │   ├── list.sh
│   │   ├── run.sh
│   │   ├── exec.sh
│   │   └── doctor.sh
│   │
│   ├── log.sh                 # Logging functions
│   ├── config.sh              # Configuration helpers
│   ├── ui.sh                  # User interaction
│   ├── platform.sh            # Platform detection
│   ├── copy.sh                # File copying
│   ├── hooks.sh               # Hook system
│   └── core/                  # Core worktree logic
│       ├── worktree.sh
│       └── loader.sh
│
├── adapters/
│   ├── editor/                # Editor integrations
│   │   ├── cursor.sh
│   │   ├── vscode.sh
│   │   ├── vim.sh
│   │   └── ...
│   └── ai/                    # AI tool integrations
│       ├── claude.sh
│       ├── copilot.sh
│       └── ...
│
├── .wtr/                      # NEW: Project configuration
│   ├── config.sh              # Project-level defaults
│   └── hooks/                 # Lifecycle hooks
│       ├── post-create.sh
│       └── pre-remove.sh
│
└── test/
    ├── commands/              # NEW: Command tests
    │   └── dispatch.bats
    ├── adapters/              # NEW: Adapter tests
    │   ├── adapter-contract.bats
    │   └── adapter-detect.bats
    └── ...
```

## Execution Flow

```
User Input
    ↓
bin/wtr [command] [args]
    ↓
Load libraries:
  - log.sh (logging)
  - config.sh (configuration)
  - platform.sh (OS detection)
  - core.sh (dispatch system)
    ↓
Load project config (if .wtr/config.sh exists)
    ↓
main() {
  dispatch_command "$@"
}
    ↓
dispatch_command() {
  case "$cmd" in
    add|create|new) cmd_add "$@" ;;
    ...
  esac
}
    ↓
cmd_add/cmd_remove/cmd_list/etc.
    ↓
Output via log_* functions to stderr
Return exit code
```

## Command Dispatch Table

| User Input | Dispatches To | File | Function |
|-----------|---------------|------|----------|
| `wtr add` | create alias | `lib/commands/add.sh` | `cmd_add()` |
| `wtr create` | create alias | `lib/commands/add.sh` | `cmd_add()` |
| `wtr new` | create alias | `lib/commands/add.sh` | `cmd_add()` |
| `wtr remove` | remove alias | `lib/commands/remove.sh` | `cmd_remove()` |
| `wtr rm` | remove alias | `lib/commands/remove.sh` | `cmd_remove()` |
| `wtr list` | list | `lib/commands/list.sh` | `cmd_list()` |
| `wtr ls` | list alias | `lib/commands/list.sh` | `cmd_list()` |
| `wtr run` | run | `lib/commands/run.sh` | `cmd_run()` |
| `wtr exec` | exec | `lib/commands/exec.sh` | `cmd_exec()` |
| `wtr doctor` | doctor | `lib/commands/doctor.sh` | `cmd_doctor()` |
| `wtr help` | help | `lib/core.sh` | `cmd_help()` |
| `wtr --help` | help | `lib/core.sh` | `cmd_help()` |
| `wtr -h` | help | `lib/core.sh` | `cmd_help()` |
| `wtr version` | version | `lib/core.sh` | (inline) |
| `wtr --version` | version | `lib/core.sh` | (inline) |
| `wtr -v` | version | `lib/core.sh` | (inline) |

## Command Function Pattern

Every command in `lib/commands/*.sh` follows this pattern:

```bash
#!/bin/bash
# lib/commands/example.sh

cmd_example() {
  # 1. Handle help first
  case "${1:-}" in
    -h|--help)
      cat <<'EOF'
Usage: wtr example [options]

Description of the command...

Options:
  -h, --help          Show this help
EOF
      return 0
      ;;
  esac

  # 2. Parse arguments
  local arg1="${1:-}"
  local arg2="${2:-}"

  # 3. Validate inputs
  if [ -z "$arg1" ]; then
    log_error "Argument required"
    return 1
  fi

  # 4. Execute command logic
  log_step "Doing something..."
  # ... implementation ...
  log_success "Done!"
}
```

## Configuration Hierarchy

```
Global (machine-wide)
  ↓ overrides ↓
Local (.git/config)
  ↓ overrides ↓
Project (.wtrconfig)
  ↓ overrides ↓
Project Runtime (.wtr/config.sh)
  ↓ overrides ↓
CLI Flags
```

## Error Handling

### Shell Safety
```bash
set -euo pipefail  # In bin/wtr
```

Benefits:
- **-e**: Exit on error
- **-u**: Undefined variables = error
- **-o pipefail**: Pipeline failure detected

### Error Functions (lib/errors.sh)
```bash
die()   # Exit with error message
err()   # Print error message (no exit)
```

### Logging (lib/log.sh)
```bash
log_info()    # Blue [info]
log_success() # Green [ok]
log_error()   # Red [error]
log_warn()    # Yellow [warn]
log_step()    # Cyan ==>
log_debug()   # Gray [debug] (when WTR_DEBUG=1)
```

## Adding a New Command

1. Create `lib/commands/mycommand.sh`:
```bash
#!/bin/bash
# lib/commands/mycommand.sh

cmd_mycommand() {
  case "${1:-}" in
    -h|--help)
      cat <<'EOF'
Usage: wtr mycommand [options]

Your command description...
EOF
      return 0
      ;;
  esac

  log_step "Executing mycommand..."
  # Implementation here
}
```

2. Update `lib/core.sh` dispatch (add to case statement):
```bash
mycommand)
  cmd_mycommand "$@"
  ;;
```

3. Test:
```bash
wtr mycommand --help
wtr mycommand
```

## Testing

### Run dispatch tests
```bash
bats test/commands/dispatch.bats
```

### Run adapter tests
```bash
bats test/adapters/adapter-contract.bats
bats test/adapters/adapter-detect.bats
```

### Run all tests
```bash
cd test && bats *.bats
```

## Project Configuration Example

`.wtr/config.sh`:
```bash
#!/bin/bash
export WTR_EDITOR_DEFAULT="cursor"
export WTR_AI_DEFAULT="claude"
export WTR_WORKTREES_PREFIX="wtr-"
git config wtr.hook.postCreate '.wtr/hooks/post-create.sh'
git config wtr.hook.preRemove '.wtr/hooks/pre-remove.sh'
```

`.wtr/hooks/post-create.sh`:
```bash
#!/bin/bash
# Auto-setup after worktree creation

if [ -f "package.json" ]; then
  npm ci
fi

if [ -f ".env.example" ]; then
  cp .env.example .env
fi
```

## Key Variables

| Variable | Purpose | Set In |
|----------|---------|--------|
| `WTR_DIR` | wtr installation directory | `bin/wtr` |
| `WTR_VERSION` | Version string | `bin/wtr` |
| `WTR_EDITOR_DEFAULT` | Default editor | Config or `.wtr/config.sh` |
| `WTR_AI_DEFAULT` | Default AI tool | Config or `.wtr/config.sh` |
| `WTR_WORKTREES_PREFIX` | Worktree folder prefix | Config or `.wtr/config.sh` |
| `WTR_DEBUG` | Enable debug logging | Environment |

## Common Tasks

### Create worktree with auto-setup
```bash
wtr add feature/new-ui
# Runs .wtr/hooks/post-create.sh automatically
```

### Run tests in specific worktree
```bash
wtr run feature/new-ui npm test
```

### Execute in all worktrees
```bash
wtr exec --all -- git status
```

### Check system setup
```bash
wtr doctor
```

### See command-specific help
```bash
wtr add --help
wtr remove --help
wtr run --help
```

## Debugging

Enable debug output:
```bash
export WTR_DEBUG=1
wtr add my-feature
```

Run syntax check:
```bash
bash -n bin/wtr
bash -n lib/core.sh
```

Check for undefined variables:
```bash
bash -x bin/wtr add feature 2>&1 | grep -E "^[+-]"
```

---

**Last Updated**: January 2026
**Version**: 2.0.0
**Status**: Production-Ready
