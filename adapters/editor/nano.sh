#!/usr/bin/env bash
# Nano editor adapter

cmd="$1"
worktree="$2"

case "$cmd" in
    open)
        if command -v nano >/dev/null 2>&1; then
            # Run in current terminal
            nano "$worktree"
        else
            echo "Error: nano not found on PATH" >&2
            exit 1
        fi
        ;;
    *)
        echo "Unknown command: $1" >&2
        exit 1
        ;;
esac
