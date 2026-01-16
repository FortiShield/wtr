#!/usr/bin/env bash
# Gemini AI integration adapter

cmd="$1"
worktree_path="$2"

# Configuration
GEMINI_API_KEY="${GEMINI_API_KEY:-}"
GEMINI_MODEL="gemini-1.5-pro"  # Default model

# Check for API key
if [ -z "$GEMINI_API_KEY" ]; then
    # Try to load from config file
    if [ -f "$HOME/.config/neopilot/gemini" ]; then
        # shellcheck source=/dev/null
        source "$HOME/.config/neopilot/gemini"
    fi
    
    if [ -z "$GEMINI_API_KEY" ]; then
        echo "Error: GEMINI_API_KEY not set. Please set it in your environment or ~/.config/neopilot/gemini" >&2
        exit 1
    fi
fi

# Helper function to make API calls
gemini_api() {
    local data="$1"
    
    curl -s -X POST "https://generativelanguage.googleapis.com/v1beta/models/${GEMINI_MODEL}:generateContent?key=${GEMINI_API_KEY}" \
        -H "Content-Type: application/json" \
        -d "$data"
}

case "$cmd" in
    open)
        # Check if we should analyze the repository
        if [ -d "$worktree_path" ]; then
            # Get a summary of recent changes
            cd "$worktree_path" || exit 1
            recent_changes=$(git log -n 5 --pretty=format:"%h - %s (%an, %ar)")
            
            # Prepare the prompt
            prompt="I'm working on a project. Here are the recent changes:\n$recent_changes\n\n"
            
            if [ -f "README.md" ]; then
                prompt+="Here's the project's README:\n$(head -n 50 README.md)\n\n"
            fi
            
            prompt+="What should I work on next? Please provide specific suggestions."
            
            # Call Gemini API
            response=$(gemini_api '{
                "contents": [{
                    "parts": [{"text": "'"$prompt"'"}]
                }]
            }')
            
            # Extract and display the response
            echo "🤖 Gemini's suggestions:"
            echo "$response" | jq -r '.candidates[0].content.parts[0].text' 2>/dev/null || echo "Error parsing response"
            
            # Open browser to Gemini's web interface
            if command -v xdg-open >/dev/null; then
                xdg-open "https://gemini.google.com/app" >/dev/null 2>&1 &
            elif command -v open >/dev/null; then
                open "https://gemini.google.com/app" >/dev/null 2>&1 &
            fi
        else
            echo "Worktree path does not exist: $worktree_path" >&2
            exit 1
        fi
        ;;
        
    analyze)
        # More detailed analysis of the codebase
        if [ -d "$worktree_path" ]; then
            cd "$worktree_path" || exit 1
            
            # Get code statistics
            file_count=$(find . -type f -name "*.py" -o -name "*.js" -o -name "*.ts" -o -name "*.sh" | wc -l)
            loc=$(find . -type f -name "*.py" -o -name "*.js" -o -name "*.ts" -o -name "*.sh" | xargs wc -l 2>/dev/null | tail -n 1 | awk '{print $1}')
            
            # Prepare analysis prompt
            prompt="Analyze this codebase and provide insights:\n"
            prompt+="- Files: $file_count\n"
            prompt+="- Lines of code: $loc\n\n"
            prompt+="Project structure:\n$(find . -type d -maxdepth 2 | sort | sed 's|[^/]*/|- |g' | head -n 20)\n\n"
            
            if [ -f "package.json" ]; then
                prompt+="Dependencies:\n$(jq -r '.dependencies | to_entries[] | .key + ": " + .value' package.json 2>/dev/null | head -n 10)\n\n"
            fi
            
            prompt+="What are the main components of this project? Any potential improvements or areas of concern?"
            
            # Call Gemini API
            response=$(gemini_api '{
                "contents": [{
                    "parts": [{"text": "'"$prompt"'"}]
                }]
            }')
            
            echo "📊 Codebase Analysis:"
            echo "$response" | jq -r '.candidates[0].content.parts[0].text' 2>/dev/null || echo "Error parsing response"
        fi
        ;;
        
    *)
        echo "Unknown command: $cmd" >&2
        echo "Available commands: open, analyze" >&2
        exit 1
        ;;
esac
