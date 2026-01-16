# Adapters manifest
# Lists all available editor and AI adapters

# Available editors
AVAILABLE_EDITORS=(
    "vscode"        # Visual Studio Code
    "vscode_remote" # VS Code with Remote Containers/SSH
    "nvim"          # Neovim
    "vim"           # Vim
    "emacs"         # Emacs
    "zed"           # Zed Editor
    "cursor"        # Cursor Editor
    "idea"          # IntelliJ IDEA
    "webstorm"      # WebStorm
    "pycharm"       # PyCharm
    "atom"          # Atom
    "sublime"       # Sublime Text
    "nano"          # Nano
    "antigravity"   # Google Antigravity
)

# Available AI tools
AVAILABLE_AI=(
    "aider"         # Aider AI coding assistant
    "claude"        # Claude AI
    "continue"      # Continue AI
    "codex"         # OpenAI Codex
    "copilot"       # GitHub Copilot
    "gemini"        # Google Gemini AI
    "cursor"        # Cursor AI editor
    "opencode"      # OpenCode Interpreter
    "antigravity"   # Google Antigravity
)

# Verify an adapter exists
adapter_exists() {
    local type="$1"
    local name="$2"
    
    if [ "$type" = "editor" ]; then
        for editor in "${AVAILABLE_EDITORS[@]}"; do
            [ "$editor" = "$name" ] && return 0
        done
    elif [ "$type" = "ai" ]; then
        for ai in "${AVAILABLE_AI[@]}"; do
            [ "$ai" = "$name" ] && return 0
        done
    fi
    
    return 1
}
