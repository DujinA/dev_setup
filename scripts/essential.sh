#!/usr/bin/env bash

sudo apt -y update
sudo apt -y install git ripgrep batcat pavucontrol xclip jq yq tldr shutter python3-pip

git clone git@github.com:junegunn/fzf.git $HOME/personal/fzf
$HOME/personal/fzf/install
