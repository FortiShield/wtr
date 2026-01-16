#!/usr/bin/env bash
# Aider AI integration adapter

cmd="$1"
worktree_path="$2"
shift 2

case "$cmd" in
    open|start)
        if command -v aider >/dev/null 2>&1; then
            echo "🤖 Starting Aider in $worktree_path..."
            (cd "$worktree_path" && aider "$@")
        else
            echo "Error: aider not found on PATH. Install it with: pip install aider-chat" >&2
            exit 1
        fi
        ;;
    *)
        echo "Unknown command: $cmd" >&2
        exit 1
        ;;
esac
