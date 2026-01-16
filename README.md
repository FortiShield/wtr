# Neopilot BranchOps

Portable, cross-platform git worktree management.

## Installation

### Automatic Install

You can install BranchOps using the provided installation script. This script will detect your platform and shell, install the necessary files, and set up shell integration.

```bash
./install.sh
```

### Manual Installation

1. Copy the `bin`, `lib`, `adapters`, and `completions` directories to your desired installation path (e.g., `~/.branchops`).
2. Add the `bin` directory to your `PATH`.
3. Source the appropriate completion script in your shell configuration.

## Usage

```bash
git branchops help
```

## Examples

The `examples/` directory contains templates and scripts to help you get started:

- **[.branchopsconfig](examples/.branchopsconfig)**: Template for shared repository configuration.
- **[Hooks](examples/hooks/)**: Example scripts for post-creation and pre-removal automation.
- **[Presets](examples/presets.gitconfig)**: Git configuration snippets for common worktree workflows.
- **[Setup Script](examples/scripts/setup-project.sh)**: A utility to quickly initialize BranchOps in a new project.

See the [Configuration Guide](docs/configuration.md) for detailed information on how to customize BranchOps.
