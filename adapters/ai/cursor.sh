#!/usr/bin/env bash
# Cursor AI integration adapter
# This adapter focuses on the AI capabilities of Cursor

cmd="$1"
worktree_path="$2"
shift 2

case "$cmd" in
    open|start)
        if command -v cursor >/dev/null 2>&1; then
            echo "🤖 Opening Cursor with AI capabilities in $worktree_path..."
            cursor "$worktree_path" "$@"
        else
            echo "Error: cursor not found on PATH." >&2
            exit 1
        fi
        ;;
    *)
        echo "Unknown command: $cmd" >&2
        exit 1
        ;;
esac
