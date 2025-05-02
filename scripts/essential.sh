#!/usr/bin/env bash

sudo dnf -y update
sudo dnf -y install git ripgrep bat pavucontrol xclip jq yq tldr shutter python3-pip

git clone git@github.com:junegunn/fzf.git $HOME/personal/fzf
$HOME/personal/fzf/install
