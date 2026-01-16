#!/usr/bin/env bash
# setup-project.sh - Initialize branchops in a new repository
# Usage: ./setup-project.sh

set -e

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
if [ -z "$REPO_ROOT" ]; then
    echo "Error: Not a git repository."
    exit 1
fi

cd "$REPO_ROOT"

echo "==> Initializing branchops in $REPO_ROOT..."

# 1. Create directory structure
mkdir -p .branchops/hooks

# 2. Copy example config if it doesn't exist
if [ ! -f ".branchopsconfig" ]; then
    echo "Creating .branchopsconfig..."
    cat > .branchopsconfig <<EOF
[copy]
    include = .env.example
    # includeDirs = node_modules

[hooks]
    postCreate = "./.branchops/hooks/post-create.sh"
    preRemove = "./.branchops/hooks/pre-remove.sh"
EOF
fi

# 3. Create basic hooks
if [ ! -f ".branchops/hooks/post-create.sh" ]; then
    echo "Creating .branchops/hooks/post-create.sh..."
    cat > .branchops/hooks/post-create.sh <<EOF
#!/usr/bin/env bash
set -e
echo "Created worktree: \$(pwd)"
if [ -f ".env.example" ] && [ ! -f ".env" ]; then
    cp .env.example .env
    echo "Initialized .env"
fi
EOF
    chmod +x .branchops/hooks/post-create.sh
fi

echo "==> Done! branchops is configured for this project."
echo "You can now commit .branchopsconfig and .branchops/hooks/"
