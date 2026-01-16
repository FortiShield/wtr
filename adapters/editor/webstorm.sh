#!/usr/bin/env bash
# WebStorm editor adapter

cmd="$1"
worktree="$2"

case "$cmd" in
    open)
        if command -v webstorm >/dev/null 2>&1; then
            webstorm "$worktree" >/dev/null 2>&1 &
        elif [ -d "/Applications/WebStorm.app" ]; then
            open -a "WebStorm" "$worktree"
        else
            echo "Error: webstorm command or WebStorm.app not found" >&2
            exit 1
        fi
        ;;
    *)
        echo "Unknown command: $1" >&2
        exit 1
        ;;
esac
