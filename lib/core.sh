# core.sh - core loader
for f in "$BRANCHOPS_DIR/lib/core"/*.sh; do
  [ -f "$f" ] && . "$f"
done
