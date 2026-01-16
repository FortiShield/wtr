#!/usr/bin/env bash
cmd="$1"
worktree="$2"
case "$cmd" in
  open)
    local target="${3:-$worktree}"
    if command -v antigravity >/dev/null 2>&1; then
      antigravity "$target" >/dev/null 2>&1 &
    else
      echo "Antigravity CLI not found. Please install it or check your PATH."
      exit 1
    fi
    ;;
esac
