#!/usr/bin/env bash
set -euo pipefail

DRY_RUN=0

usage() {
  printf 'Usage: %s [--dry-run]\n' "$(basename "$0")"
}

while (($#)); do
  case "$1" in
    --dry-run)
      DRY_RUN=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      usage >&2
      exit 1
      ;;
  esac
  shift
done

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd -- "$SCRIPT_DIR/.." && pwd)
BACKUP_SUFFIX="bak.$(date +%Y%m%d-%H%M%S)"

run() {
  printf '+ '
  printf '%q ' "$@"
  printf '\n'

  if ((DRY_RUN == 0)); then
    "$@"
  fi
}

backup_file() {
  local target=$1

  if [[ -e "$target" && ! -L "$target" ]]; then
    run cp -p -- "$target" "$target.$BACKUP_SUFFIX"
  elif [[ -L "$target" ]]; then
    run cp -P -- "$target" "$target.$BACKUP_SUFFIX"
  fi
}

copy_file() {
  local source=$1
  local target=$2
  local mode=${3:-}

  if [[ ! -f "$source" ]]; then
    printf 'Missing source file: %s\n' "$source" >&2
    exit 1
  fi

  run mkdir -p -- "$(dirname -- "$target")"
  backup_file "$target"
  run cp -p -- "$source" "$target"

  if [[ -n "$mode" ]]; then
    run chmod "$mode" "$target"
  fi
}

copy_dir_contents() {
  local source_dir=$1
  local target_dir=$2

  if [[ ! -d "$source_dir" ]]; then
    printf 'Missing source directory: %s\n' "$source_dir" >&2
    exit 1
  fi

  run mkdir -p -- "$target_dir"

  while IFS= read -r -d '' source; do
    local rel=${source#"$source_dir/"}
    local target="$target_dir/$rel"

    copy_file "$source" "$target"
  done < <(find "$source_dir" -path '*/.git' -prune -o -type f -print0)
}

copy_file "$REPO_ROOT/.config/ghostty/config" "$HOME/.config/ghostty/config"
copy_file "$REPO_ROOT/.config/ideavim/.ideavimrc" "$HOME/.ideavimrc"
copy_dir_contents "$REPO_ROOT/.config/nvim-config" "$HOME/.config/nvim"
copy_file "$REPO_ROOT/.config/tmux/.tmux.conf" "$HOME/.tmux.conf"
copy_file "$REPO_ROOT/.config/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"
copy_file "$REPO_ROOT/.gitconfig" "$HOME/.gitconfig"
copy_file "$REPO_ROOT/.zsh_profile" "$HOME/.zsh_profile"
copy_file "$REPO_ROOT/.zshrc" "$HOME/.zshrc"
copy_file "$REPO_ROOT/tmux-sessionizer" "$HOME/.local/scripts/tmux-sessionizer" "755"

if ((DRY_RUN)); then
  printf 'Dry run complete. No files were changed.\n'
else
  printf 'Config files copied successfully.\n'
fi
