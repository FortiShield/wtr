#!/usr/bin/env bash
# Emacs editor adapter

cmd="$1"
worktree="$2"

case "$cmd" in
    open)
        if command -v emacsclient >/dev/null 2>&1; then
            emacsclient -n "$worktree" >/dev/null 2>&1 &
        elif command -v emacs >/dev/null 2>&1; then
            emacs "$worktree" >/dev/null 2>&1 &
        else
            echo "Error: emacs or emacsclient not found" >&2
            exit 1
        fi
        ;;
    *)
        echo "Unknown command: $1" >&2
        exit 1
        ;;
esac
