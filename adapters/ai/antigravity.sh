#!/usr/bin/env bash
# Antigravity AI integration adapter

cmd="$1"
worktree_path="$2"

# Configuration
ANTIGRAVITY_API_KEY="${ANTIGRAVITY_API_KEY:-}"
ANTIGRAVITY_MODEL="antigravity-1.0-pro"  # Default model

# Check for API key
if [ -z "$ANTIGRAVITY_API_KEY" ]; then
    # Try to load from config file
    if [ -f "$HOME/.config/neopilot/antigravity" ]; then
        # shellcheck source=/dev/null
        source "$HOME/.config/neopilot/antigravity"
    fi
    
    if [ -z "$ANTIGRAVITY_API_KEY" ]; then
        echo "Error: ANTIGRAVITY_API_KEY not set. Please set it in your environment or ~/.config/neopilot/antigravity" >&2
        exit 1
    fi
fi

# Helper function to make API calls
antigravity_api() {
    local data="$1"
    
    # Placeholder endpoint for Antigravity API
    curl -s -X POST "https://api.antigravity.google.com/v1/models/${ANTIGRAVITY_MODEL}:generateContent?key=${ANTIGRAVITY_API_KEY}" \
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
            
            # Call Antigravity API
            response=$(antigravity_api '{
                "contents": [{
                    "parts": [{"text": "'"$prompt"'"}]
                }]
            }')
            
            # Extract and display the response
            echo "🪐 Antigravity's suggestions:"
            echo "$response" | jq -r '.candidates[0].content.parts[0].text' 2>/dev/null || echo "Error parsing response"
            
            # Open browser to Antigravity's web interface
            if command -v xdg-open >/dev/null; then
                xdg-open "https://antigravity.google.com/app" >/dev/null 2>&1 &
            elif command -v open >/dev/null; then
                open "https://antigravity.google.com/app" >/dev/null 2>&1 &
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
            
            # Call Antigravity API
            response=$(antigravity_api '{
                "contents": [{
                    "parts": [{"text": "'"$prompt"'"}]
                }]
            }')
            
            echo "📊 Antigravity Codebase Analysis:"
            echo "$response" | jq -r '.candidates[0].content.parts[0].text' 2>/dev/null || echo "Error parsing response"
        fi
        ;;
        
    *)
        echo "Unknown command: $cmd" >&2
        echo "Available commands: open, analyze" >&2
        exit 1
        ;;
esac
