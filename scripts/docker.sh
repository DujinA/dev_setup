#!/usr/bin/env bash

sudo pacman -Syu
sudo pacman -S docker --noconfirm
sudo systemctl start docker.service
sudo systemctl enable docker.service
sudo groupadd docker
sudo usermod -aG docker $USER
sudo pacman -S docker-compose

