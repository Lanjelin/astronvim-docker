FROM alpine:3.18.3

RUN \
  apk --no-cache add --update \
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
    --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/ \
    gdu && \
  mkdir -p /edit

COPY entrypoint.sh .

VOLUME /root
WORKDIR /root

EXPOSE 7681
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/bin/bash", "/entrypoint.sh"]
