#!/usr/bin/env bash
cmd="$1"
worktree="$2"
case "$cmd" in
  open)
    local target="${3:-$worktree}"
    code "$target" >/dev/null 2>&1 &
    ;;
  *)
    echo "unknown"
    ;;
esac
