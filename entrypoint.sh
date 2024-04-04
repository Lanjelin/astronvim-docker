#!/bin/bash
if ! [ -f "/root/.zshrc" ]; then
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
if [ ! -d "/root/.config/nvim" ]; then
	git clone --depth 1 https://github.com/AstroNvim/template /root/.config/nvim
	rm -rf /root/.config/nvim/.git
fi
nvim
