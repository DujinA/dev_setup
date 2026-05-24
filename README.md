# dev_setup

Personal Arch Linux development setup with install scripts and dotfiles.

## What Is Included

- Package install scripts for core tools, zsh, tmux, Neovim, Ghostty, Docker, Node, Maven, Gradle, Obsidian, Homebrew, and power profiles.
- Dotfiles for zsh, tmux, Git, Ghostty, IdeaVim, Hyprland, and Neovim.
- Neovim config as a submodule at `.config/nvim-config`.
- `tmux-sessionizer` helper script installed to `~/.local/scripts/tmux-sessionizer`.

## Usage

Run the full install sequence:

```sh
./scripts/install-all.sh
```

Preview the commands without changing files:

```sh
./scripts/install-all.sh --dry-run
```

Skip copying and reloading Hyprland config:

```sh
./scripts/install-all.sh --skip-hypr
```

Config copy scripts back up existing target files with a timestamped `.bak.YYYYMMDD-HHMMSS` suffix before replacing them.
