#!/usr/bin/env bash

sudo pacman -S nodejs npm --noconfirm
npm config set prefix ~/.local/npm
npm i -g n
n lts

curl -fsSL https://deno.land/install.sh | sh
curl -fsSL https://bun.sh/install | bash
curl -fsSL https://get.pnpm.io/install.sh | sh -
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v1.40.3/install.sh | bash
