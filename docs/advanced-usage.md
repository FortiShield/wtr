# Advanced Usage & Workflows

This guide covers advanced patterns and power-user workflows to help you get the most out of BranchOps.

## Parallel Development Patterns

One of the most powerful features of Git worktrees is the ability to work on multiple aspects of the same project simultaneously.

### Variant Worktrees
Sometimes you need to test two different approaches to the same feature, or work on the frontend and backend of a branch in parallel.

Use the `--force` and `--name` flags to create multiple worktrees for the same branch:

```bash
# Main development worktree
git branchops new feature/auth

# Frontend-only variant
git branchops new feature/auth --force --name frontend

# Backend-only variant
git branchops new feature/auth --force --name backend
```

This creates three separate directories:
- `feature-auth`
- `feature-auth-frontend`
- `feature-auth-backend`

### Working from Current State
If you've already started work on a branch and want to spawn a parallel worktree from your current HEAD (including commits not yet pushed):

```bash
git branchops new feature/auth-refactor --from-current
```

## Advanced Automation with Hooks

Hooks allow you to automate the "boring parts" of setting up and tearing down dev environments.

### The "Auto-Install" Pattern
In repositories with heavy dependencies, use `postCreate` hooks to ensure your environment is ready as soon as you `cd` in.

Add to your `.branchopsconfig`:
```ini
[hooks]
    # Install dependencies automatically
    postCreate = npm install
    # For Python projects
    postCreate = [ -f requirements.txt ] && pip install -r requirements.txt
```

### Environment Synchronization
If you frequently change `.env` files or configuration, use `postCreate` to sync them or `preRemove` to back them up.

```ini
[hooks]
    # Copy local secrets that aren't in the main repo
    postCreate = cp ../.env.local .env
```

### Safety Checks with `preRemove`
You can prevent accidental deletion of worktrees that have running processes or uncommited data that wasn't copied back.

```ini
[hooks]
    # Prevent removal if a docker container is running
    preRemove = ! docker ps | grep -q "$(basename $WORKTREE_PATH)"
```

## Monorepo Workflows

Managing monorepos (like Turborepo or Nx) with worktrees requires a bit more coordination.

### Sub-app Scoping
If you only care about a specific package in a monorepo, you can use hooks to scope your editor to just that directory.

```bash
git branchops config set branchops.hook.postCreate "cd packages/api && npm install" --local
```

### Shared Dependency Management
In monorepos, `node_modules` at the root can be massive. Instead of re-installing, use `includeDirs` to copy them (if on the same filesystem/OS):

```ini
[copy]
    includeDirs = node_modules
    # Exclude heavy cache directories to speed up copying
    excludeDirs = node_modules/.cache
```

## Synchronizing Worktrees

As you work on a feature, you might update a shared configuration file or a `.env.example` in one worktree and need it in others.

### Selective Copying
Use the `copy` command to push specific files from your main repo to one or all worktrees:

```bash
# Push latest .env.example to a specific worktree
git branchops copy feature-auth -- .env.example

# Sync a specific directory to ALL active worktrees
git branchops copy -a -- "src/types/*"
```

## Hygiene & Maintenance

### Merged PR Cleanup
Once a Pull Request is merged, the worktree and local branch are no longer needed. BranchOps can verify the PR state on GitHub and clean them up for you:

```bash
# Requires GitHub CLI (gh)
git branchops clean --merged
```

### The "Doctor" Checkup
If something feels wrong (e.g., commands not found, paths broken), run the doctor command to verify your installation:

```bash
git branchops doctor
```

## Shell Integration Tricks

### Path Navigation
Add an alias to your shell (`.zshrc` or `.bashrc`) to quickly jump into worktrees:

```bash
# Jump and go
alias bgo='cd $(git branchops go $1)'
```

Usage: `bgo my-feature`

### Quick Action Chains
Chain commands for a "one-touch" setup:

```bash
# Create, open in editor, and start AI in one go
git branchops new hotfix/urgent && git branchops editor hotfix/urgent && git branchops ai hotfix/urgent
```
