# platform.sh - platform detection

detect_shell() {
  printf '%s' "${SHELL##*/}"
}

detect_os() {
  local os_name
  os_name="$(uname -s)"
  case "$os_name" in
    Darwin*)  echo "macos" ;;
    Linux*)   echo "linux" ;;
    MSYS*|MINGW*|CYGWIN*) echo "windows" ;;
    *)        echo "unknown" ;;
  esac
}

is_git_repo_root() {
  git rev-parse --show-toplevel >/dev/null 2>&1
}
