#!/usr/bin/env bash

sudo apt install nodejs npm
npm config set prefix ~/.local/npm
npm i -g n
n lts

curl -fsSL https://deno.land/install.sh | sh
curl -fsSL https://bun.sh/install | bash
curl -fsSL https://get.pnpm.io/install.sh | sh -
