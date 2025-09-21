#!/usr/bin/env bash

sudo pacman -Syu
sudo pacman -S git-delta pavucontrol xclip yq python-pip nvidia-settings lua51 stylua gimp bluez blueman

git clone git@github.com:junegunn/fzf.git $HOME/personal/fzf
$HOME/personal/fzf/install
