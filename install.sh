#!/usr/bin/env bash
# git-core/install.sh
set -euo pipefail
_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
_BIN="$_ROOT/cli/bin"
_USER_BIN="${HOME}/bin"
_RC="${HOME}/.bashrc"

printf '\n  git-core install\n  ────────────────\n\n'
mkdir -p "$_USER_BIN"
chmod +x "$_BIN"/*

# Symlinks
for f in "$_BIN"/*; do
    ln -sf "$f" "$_USER_BIN/$(basename "$f")"
    printf '  ~  Linked: %s\n' "$(basename "$f")"
done

# Completion symlink
_COMP_DIR="$HOME/.local/share/xspace"
mkdir -p "$_COMP_DIR"
[[ -f "$_ROOT/completion/gitspace-completion.sh" ]] && \
    ln -sf "$_ROOT/completion/gitspace-completion.sh" "$_COMP_DIR/gitspace-completion.sh" && \
    printf '  ~  Linked: gitspace-completion.sh\n'

printf '\n  Done. Run: source ~/.bashrc\n\n'
