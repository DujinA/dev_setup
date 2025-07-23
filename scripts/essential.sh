#!/usr/bin/env bash

sudo pacman -Syu
sudo pacman -S git curl git-delta ripgrep bat pavucontrol xclip jq yq tldr shutter python-pip nvidia nvidia-utils nvidia-settings rofi stylua btop gimp

git clone git@github.com:junegunn/fzf.git $HOME/personal/fzf
$HOME/personal/fzf/install
