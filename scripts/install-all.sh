#!/usr/bin/env bash
set -euo pipefail

DRY_RUN=0
SKIP_HYPR=0

usage() {
  printf 'Usage: %s [--dry-run] [--skip-hypr]\n' "$(basename "$0")"
}

while (($#)); do
  case "$1" in
    --dry-run)
      DRY_RUN=1
      ;;
    --skip-hypr)
      SKIP_HYPR=1
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

run_script() {
  local script=$1
  shift || true

  printf '\n==> %s\n' "$script"

  if [[ ! -f "$SCRIPT_DIR/$script" ]]; then
    printf 'Missing script: %s\n' "$SCRIPT_DIR/$script" >&2
    exit 1
  fi

  if ((DRY_RUN)); then
    printf '+ %q' "$SCRIPT_DIR/$script"
    if (($#)); then
      printf ' %q' "$@"
    fi
    printf '\n'
    return
  fi

  bash "$SCRIPT_DIR/$script" "$@"
}

install_scripts=(
  essential.sh
  paru.sh
  zsh.sh
  powerlevel10k.sh
  zsh_plugins.sh
  tmux.sh
  neovim.sh
  ghostty.sh
  docker.sh
  node.sh
  maven.sh
  gradle.sh
  obsidian.sh
  power_profiles_daemon.sh
  brew.sh
)

for script in "${install_scripts[@]}"; do
  run_script "$script"
done

config_args=()
if ((DRY_RUN)); then
  config_args+=(--dry-run)
fi

run_script copy-configs.sh "${config_args[@]}"

if ((SKIP_HYPR)); then
  printf '\n==> copy-hypr-configs.sh\n'
  printf 'Skipped Hyprland config copy.\n'
else
  run_script copy-hypr-configs.sh "${config_args[@]}"
fi

printf '\nInstall sequence complete.\n'
