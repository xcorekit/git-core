#!/usr/bin/env bash
# git-core/install.sh
# ─────────────────────────────────────────────────────────────────────────────
# CHANGELOG (newest first)
# ─────────────────────────────────────────────────────────────────────────────
#   2026-05-03  Rewritten — cli/ layout, clean PATH guard, no dead paths
#   2026-04-30  Initial standalone installer
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
_BIN="$_ROOT/cli/bin"
_LIB="$_ROOT/cli/lib"
_USER_BIN="${HOME}/bin"
_RC="${HOME}/.bashrc"

printf '\n  git-core install\n  ────────────────\n\n'

mkdir -p "$_USER_BIN"
chmod +x "$_BIN"/*

# PATH guard — idempotent
if ! grep -qF "$_BIN" "$_RC" 2>/dev/null; then
    printf '\n# git-core\nexport PATH="$PATH:%s"\n' "$_BIN" >> "$_RC"
    printf '  +  Added cli/bin to PATH\n'
else
    printf '  ✓  Already in PATH\n'
fi

# Symlinks
for f in "$_BIN"/*; do
    ln -sf "$f" "$_USER_BIN/$(basename "$f")"
    printf '  ~  Linked: %s\n' "$(basename "$f")"
done

# Tab completion — stable symlink
_COMPLETION_DIR="$HOME/.local/share/xspace"
_COMPLETION_SRC="$_ROOT/completion/gitspace-completion.sh"
mkdir -p "$_COMPLETION_DIR"
if [[ -f "$_COMPLETION_SRC" ]]; then
    ln -sf "$_COMPLETION_SRC" "$_COMPLETION_DIR/gitspace-completion.sh"
    _COMP_LINE="source \"$_COMPLETION_DIR/gitspace-completion.sh\""
    if ! grep -qF "$_COMPLETION_DIR/gitspace-completion.sh" "$_RC" 2>/dev/null; then
        printf '\n# git-core completion\n%s\n' "$_COMP_LINE" >> "$_RC"
        printf '  +  Wired tab completion\n'
    else
        printf '  ✓  Completion already wired\n'
    fi
fi

printf '\n  Done.\n  Run: source ~/.bashrc\n  Then: commitx --help\n\n'
