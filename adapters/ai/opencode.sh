#!/usr/bin/env bash
# OpenCode interpreter integration adapter

cmd="$1"
worktree_path="$2"
shift 2

case "$cmd" in
    open|start)
        if command -v opencode >/dev/null 2>&1; then
            echo "🤖 Starting OpenCode in $worktree_path..."
            (cd "$worktree_path" && opencode "$@")
        else
            echo "Error: opencode not found on PATH." >&2
            echo "Please ensure the OpenCode interpreter is installed and available in your PATH." >&2
            exit 1
        fi
        ;;
    analyze)
         if command -v opencode >/dev/null 2>&1; then
            echo "🔍 Running OpenCode analysis in $worktree_path..."
            # Assuming 'analyze' is a valid subcommand or we just start it
             (cd "$worktree_path" && opencode analyze "$@")
        else
             echo "Error: opencode not found on PATH." >&2
             exit 1
        fi
        ;;
    *)
        echo "Unknown command: $cmd" >&2
        exit 1
        ;;
esac
