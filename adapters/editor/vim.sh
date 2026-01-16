#!/usr/bin/env bash
# Vim editor adapter

cmd="$1"
worktree="$2"

case "$cmd" in
    open)
        if command -v vim >/dev/null 2>&1; then
            # Run in current terminal
            vim "$worktree"
        else
            echo "Error: vim not found on PATH" >&2
            exit 1
        fi
        ;;
    *)
        echo "Unknown command: $1" >&2
        exit 1
        ;;
esac
