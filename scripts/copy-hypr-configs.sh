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

  if [[ ! -f "$source" ]]; then
    printf 'Missing source file: %s\n' "$source" >&2
    exit 1
  fi

  run mkdir -p -- "$(dirname -- "$target")"
  backup_file "$target"
  run cp -p -- "$source" "$target"
}

copy_file "$REPO_ROOT/.config/hypr/autostart.conf" "$HOME/.config/hypr/autostart.conf"
copy_file "$REPO_ROOT/.config/hypr/bindings.conf" "$HOME/.config/hypr/bindings.conf"
copy_file "$REPO_ROOT/.config/hypr/hypridle.conf" "$HOME/.config/hypr/hypridle.conf"
copy_file "$REPO_ROOT/.config/hypr/hyprland.conf" "$HOME/.config/hypr/hyprland.conf"
copy_file "$REPO_ROOT/.config/hypr/hyprlock.conf" "$HOME/.config/hypr/hyprlock.conf"
copy_file "$REPO_ROOT/.config/hypr/hyprsunset.conf" "$HOME/.config/hypr/hyprsunset.conf"
copy_file "$REPO_ROOT/.config/hypr/input.conf" "$HOME/.config/hypr/input.conf"
copy_file "$REPO_ROOT/.config/hypr/monitors.conf" "$HOME/.config/hypr/monitors.conf"
copy_file "$REPO_ROOT/.config/hypr/xdph.conf" "$HOME/.config/hypr/xdph.conf"

if ((DRY_RUN)); then
  printf 'Dry run complete. Hyprland was not reloaded.\n'
else
  if command -v hyprctl >/dev/null; then
    run hyprctl reload
    run hyprctl configerrors
  else
    printf 'hyprctl not found; skipped Hyprland reload and validation.\n'
  fi

  printf 'Hypr config files copied successfully.\n'
fi
