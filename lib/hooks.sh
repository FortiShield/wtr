# hooks.sh - hook runner

# Run hooks in a specific directory
# args: hook_name, target_dir, [env_vars...]
run_hooks_in() {
  local hook_name="$1"
  local target_dir="$2"
  shift 2 || true

  [ "${BRANCHOPS_SKIP_HOOKS:-}" = "1" ] && return 0

  local repo_root
  repo_root=$(discover_repo_root) || return 0

  local hook_files=()
  # Search order:
  # 1. .branchops/hooks/<name>
  # 2. .branchops/hooks/<name>.d/*
  # 3. Legacy hooks/<name>
  
  [ -f "$repo_root/.branchops/hooks/$hook_name" ] && hook_files+=("$repo_root/.branchops/hooks/$hook_name")
  
  if [ -d "$repo_root/.branchops/hooks/$hook_name.d" ]; then
    while read -r f; do
      hook_files+=("$f")
    done < <(find "$repo_root/.branchops/hooks/$hook_name.d" -maxdepth 1 -type f -executable | sort)
  fi
  
  [ -f "$repo_root/hooks/$hook_name" ] && hook_files+=("$repo_root/hooks/$hook_name")

  # Also check config-based hooks (branchops.hook.<name>)
  local config_hooks
  config_hooks=$(cfg_get_all "branchops.hook.$hook_name")

  # Execute
  for hook in "${hook_files[@]}"; do
    log_info "Running hook: $(basename "$hook")"
    (
      # Export standard env vars
      export BRANCHOPS_HOOK="$hook_name"
      export BRANCHOPS_TARGET_DIR="$target_dir"
      export BRANCHOPS_REPO_ROOT="$repo_root"
      # Export additional vars passed as args
      [ -n "${*:-}" ] && export "$@"
      
      cd "$target_dir" && bash "$hook" "$target_dir"
    ) || {
      log_error "Hook failed: $(basename "$hook")"
      return 1
    }
  done

  if [ -n "$config_hooks" ]; then
    while read -r cmd; do
      [ -z "$cmd" ] && continue
      log_info "Running config hook: $cmd"
      (
        export BRANCHOPS_HOOK="$hook_name"
        export BRANCHOPS_TARGET_DIR="$target_dir"
        export BRANCHOPS_REPO_ROOT="$repo_root"
        [ -n "${*:-}" ] && export "$@"
        
        cd "$target_dir" && eval "$cmd"
      ) || {
        log_error "Config hook failed: $cmd"
        return 1
      }
    done <<< "$config_hooks"
  fi

  return 0
}

# Run hooks in the current context (main repo)
run_hooks() {
  local hook_name="$1"
  shift
  local repo_root
  repo_root=$(discover_repo_root) || return 0
  run_hooks_in "$hook_name" "$repo_root" "$@"
}

# Legacy alias
run_hook() {
  run_hooks_in "$1" "$2"
}
