{ config, pkgs, ... }:

{
  home.username = "dominikgarciabertapelle";
  home.homeDirectory = "/Users/dominikgarciabertapelle";

  home.stateVersion = "24.05";

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    _1password-cli
    ast-grep
    atuin
    autoconf
    automake
    avrdude
    bash
    bat
    bun
    coreutils
    csvkit
    efm-langserver
    eza
    fd
    ffmpeg
    ffmpegthumbnailer
    fnm
    fontforge
    fzf
    gcc
    gh
    ghostscript
    git
    git-absorb
    git-lfs
    gnupg
    gnused
    go
    imagemagick
    ice-bar
    jq
    kanata
    keycastr
    lazygit
    lazysql
    lf
    llvm
    lsd
    lua-language-server
    luajit
    luarocks
    ncdu
    neovim
    orbstack
    pgcli
    pigz
    pinentry_mac
    pnpm
    pyenv
    ripgrep
    sesh
    starship
    stow
    terraform
    tmux
    tree-sitter
    unar
    uv
    w3m
    wget
    yazi
    yq-go
    zoxide
    delta
  ];

  programs.home-manager.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
