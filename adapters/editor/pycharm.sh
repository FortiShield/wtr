#!/usr/bin/env bash
# PyCharm editor adapter

cmd="$1"
worktree="$2"

case "$cmd" in
    open)
        if command -v pycharm >/dev/null 2>&1; then
            pycharm "$worktree" >/dev/null 2>&1 &
        elif [ -d "/Applications/PyCharm.app" ]; then
            open -a "PyCharm" "$worktree"
        else
            echo "Error: pycharm command or PyCharm.app not found" >&2
            exit 1
        fi
        ;;
    *)
        echo "Unknown command: $1" >&2
        exit 1
        ;;
esac
