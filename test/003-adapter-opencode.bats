#!/usr/bin/env bats

setup() {
  TMP=$(mktemp -d)
  
  # Mock opencode
  mkdir -p "$TMP/bin"
  echo "#!/bin/bash" > "$TMP/bin/opencode"
  echo "echo 'MOCK_OPENCODE_CALLED with args: \$*'" >> "$TMP/bin/opencode"
  chmod +x "$TMP/bin/opencode"
  export PATH="$TMP/bin:$PATH"

  # Setup branchops env
  BOP="$(pwd)/bin/branchops"
}

teardown() {
  rm -rf "$TMP"
}

@test "opencode adapter: open command" {
  export BRANCHOPS_DIR="$(pwd)"
  run "$BOP" ai current-branch --ai opencode -- open --test-flag
  
  # It should find the mock opencode and run it
  [ "$status" -eq 0 ]
  [[ "$output" =~ "MOCK_OPENCODE_CALLED with args: --test-flag" ]]
}

@test "opencode adapter: analyze command" {
  export BRANCHOPS_DIR="$(pwd)"
  run "$BOP" ai current-branch --ai opencode -- analyze --deep
  
  [ "$status" -eq 0 ]
  [[ "$output" =~ "MOCK_OPENCODE_CALLED with args: analyze --deep" ]]
}
