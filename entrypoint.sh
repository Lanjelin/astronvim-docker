#!/bin/bash
if ! [ -f "/root/.zshrc" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
if [ ! -d "/root/.config/nvim" ]; then
  git clone --depth 1 https://github.com/AstroNvim/AstroNvim /root/.config/nvim
  rm -rf /root/.config/nvim/.git
fi
if [ ! -d "/root/.config/nvim/lua/user" ]; then
  git clone https://github.com/AstroNvim/user_example /root/.config/nvim/lua/user
  rm -rf /root/.config/nvim/lua/user/.git
fi
nvim
