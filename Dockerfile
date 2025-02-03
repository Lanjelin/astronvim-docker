FROM alpine:3.21.2

RUN \
  apk --no-cache add --update \
    unzip \
    wget \
    curl \
    gzip \
    bash \
    npm \
    cargo \
    yarn \
    python3 \
    git \
    lazygit \
    neovim \
    neovim-doc \
    ripgrep \
    bottom \
    alpine-sdk \
    tini \
    zsh \
    ttyd && \
  apk --no-cache add --update \
    --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community/ \
    gdu && \
  mkdir -p /edit

COPY entrypoint.sh .

VOLUME /root
WORKDIR /root

EXPOSE 7681
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/bin/bash", "/entrypoint.sh"]
