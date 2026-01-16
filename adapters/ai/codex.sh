#!/usr/bin/env bash
# OpenAI Codex AI adapter

cmd="$1"
worktree="$2"
shift 2

case "$cmd" in
    open|start)
        echo "Note: OpenAI Codex is primarily an API-based tool."
        echo "Opening OpenAI Playground for context..."
        if command -v open >/dev/null 2>&1; then
            open "https://platform.openai.com/playground"
        else
            echo "Please visit: https://platform.openai.com/playground"
        fi
        ;;
    *)
        echo "Unknown command: $cmd" >&2
        exit 1
        ;;
esac
