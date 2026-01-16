#!/usr/bin/env bash
# IntelliJ IDEA editor adapter

cmd="$1"
worktree="$2"

case "$cmd" in
    open)
        if command -v idea >/dev/null 2>&1; then
            idea "$worktree" >/dev/null 2>&1 &
        elif [ -d "/Applications/IntelliJ IDEA.app" ]; then
            open -a "IntelliJ IDEA" "$worktree"
        else
            echo "Error: idea command or IntelliJ IDEA.app not found" >&2
            exit 1
        fi
        ;;
    *)
        echo "Unknown command: $1" >&2
        exit 1
        ;;
esac
