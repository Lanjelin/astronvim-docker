<div align="center" id="madewithlua">
    <img src="https://astronvim.com/logo/astronvim.svg" width="110", height="100">
</div>

<h1 align="center">AstroNvim-Docker</h1>

Run [AstroNvim](https://astronvim.com/) using docker, directly in your terminal, or in your favourite browser using the included [ttyd](https://github.com/tsl0922/ttyd).  
Image built on [Alpine Linux](https://hub.docker.com/_/alpine), it includes AstroNvim with [a default template](https://github.com/AstroNvim/template), zsh with [oh-my-zsh](https://ohmyz.sh/), and ttyd.

Built mainly with UnRaid in mind, but should work on other systems as well.  
It's an easy and efficient way of running AstroNvim without having to install anything else but docker.

## Installation

To persist configuration between runs, it's advised to bind the internal path `/root` to either a volume or folder on the host.

### Migration to v4.0+

The official migration guide can be found [here](https://docs.astronvim.com/configuration/v4_migration/).  
Easiest way to migrate is to start another instance by mounting a different path on the host, then compare and edit based on your old config.  
`docker run -it --rm -v /mnt/user/appdata/astronvimv4:/root ghcr.io/lanjelin/astronvim-docker:latest`

If you haven't done any changes to the config, removing the old files then following the first run should suffice.  
`cd /mnt/user/appdata/ && mv astronvim astronvim.bak`
`docker run -it --rm -v /mnt/user/appdata/astronvim:/root ghcr.io/lanjelin/astronvim-docker:latest`

### First Run

The container will install AstroNvim and oh-my-zsh on first run, and installing all packages used by AstroNvim.  
It should be run as following before attempting anything else, to ensure configurations are properly populated.

```bash
docker run -it --rm -v /mnt/user/appdata/astronvim:/root ghcr.io/lanjelin/astronvim-docker:latest
```

### CLI Usage

To run AstroNvim with the usual `nvim` command from the terminal, add the following to your `.bashrc` or `.zshrc`  
This will start the container, and mount file/directory under the path `/edit` inside the container.  
Remember to source the updated file after editing eg. `source ~/.zshrc`

```bash
nvim () {
  if [ ! $# -eq 0 ]; then
    [[ -d "$1" ]] || [[ -f "$1" ]] || touch "$1"
    [[ -f "$1" ]] && NWD="$(dirname $1)" || NWD="$(realpath $1)"
    docker run -it --rm --name AstroNvimCLI \
    -w "/edit$NWD" \
    -v "$(realpath $1)":"/edit$(realpath $1)" \
    -v /mnt/user/appdata/astronvim:/root \
    ghcr.io/lanjelin/astronvim-docker:latest \
    nvim "/edit$(realpath $1)"
  else
    docker run -it --rm --name AstroNvimCLI \
    -w "/root" \
    -v /mnt/user/appdata/astronvim:/root \
    ghcr.io/lanjelin/astronvim-docker:latest \
    nvim
  fi
}
```

### UnRaid Additional Steps

If you've followed my guide for [ZSH and oh-my-zsh with persistent history](https://github.com/Lanjelin/unraid/tree/main/zsh-omz-persistent#zsh-and-oh-my-zsh-with-persistent-history), and added the above to `.zshrc`, you should be fine at this point.  
If you're still using the default bash, a few more steps are needed to make the config persist.

#### Preferred Way

Download the file containing the function to the array, using [user scripts](https://forums.unraid.net/topic/48286-plugin-ca-user-scripts/) to copy the values to `.bash_profile`

Run the following to download the file containing the function

```bash
wget -O /mnt/user/appdata/astronvim/.astronvim.rc https://raw.githubusercontent.com/Lanjelin/astronvim-docker/main/.astronvim.rc
```

Create a new user script, set it to run `At First Array Start Only`, and paste the following.

```bash
cat /mnt/user/appdata/astronvim/.astronvim.rc >> /root/.bash_profile
```

#### Alternative Way

Download the file containing the function to the USB-drive, editing the go-file to add it to `.bash_profile` at boot.  
This will result in errors if you're to try to run nvim before the array/docker daemon is started.

Run the following to download the file containing the function

```bash
wget -O /boot/config/.astronvim.rc https://raw.githubusercontent.com/Lanjelin/astronvim-docker/main/.astronvim.rc
```

Run the following to update the go-file

```bash
echo "cat /boot/config/.astronvim.rc >> /root/.bash_profile" >> /boot/config/go
```

## TTYD Usage

The image also includes ttyd for the option to run AstroNvim (or zsh) directly from your browser.  
TTYD is run with default settings, and the WEB-UI should be available at http://localhost:7681

### UnRaid

I've included a template to make it a fast process setting this up in UnRaid.  
Simply run the following to download the template, then navigate to your Docker-tab, click Add Container, and find AstroNvim in the Template-dropdown.

```bash
wget -O /boot/config/plugins/dockerMan/templates-user/my-AstroNvim.xml https://raw.githubusercontent.com/Lanjelin/docker-templates/main/lanjelin/astronvim.xml
```

### AstroNvim in the browser

To expose only AstroNvim to the browser, the following could be used as an example.

```bash
docker run -d --name AstroNvim \
  -w "/edit" \
  -p 7681:7681 \
  -v /path/to/project:/edit \
  -v /mnt/user/appdata/astronvim:/root \
  ghcr.io/lanjelin/astronvim-docker:latest \
  ttyd nvim "/edit"
```

```yaml
services:
  astronvim-docker:
    container_name: AstroNvim
    working_dir: /edit
    ports:
      - 7681:7681
    volumes:
      - /path/to/project:/edit
      - /mnt/user/appdata/astronvim:/root
    image: ghcr.io/lanjelin/astronvim-docker:latest
    command: ttyd nvim "/edit"
```

### ZSH in the browser

If you want full shell access to the container from your browser, change the last line for something like.

```bash
docker run -d --name AstroNvim \
  -w "/edit" \
  -p 8283:7681 \
  -v /path/to/project:/edit \
  -v /mnt/user/appdata/astronvim:/root \
  ghcr.io/lanjelin/astronvim-docker:latest \
  ttyd zsh
```

```yaml
services:
  astronvim-docker:
    container_name: AstroNvim
    working_dir: /edit
    ports:
      - 7681:7681
    volumes:
      - /path/to/project:/edit
      - /mnt/user/appdata/astronvim:/root
    image: ghcr.io/lanjelin/astronvim-docker:latest
    command: ttyd zsh
```

## Icons

ttyd will not work with icons without rebuilding it from source.

To disable icons `nvim /mnt/user/appdata/astronvim/.config/nvim/lua/user/options.lua` and set `icons_enabled` to `false`.

For a terminal that supports it, [Nerd Fonts](https://www.nerdfonts.com/font-downloads) can be used.  
For other alternatives, see [AstroNvim Docs](https://docs.astronvim.com/Recipes/icons) on the matter.

## Security

The container is run with root user in order to be able to read/write files/folders it accesses.  
This always includes some risks, and the container should not be exposed to the internet without taking the proper precautions.
