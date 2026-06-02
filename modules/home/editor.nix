{ config, lib, pkgs, ... }:
{
  # Tools your config/LSPs commonly call on PATH.
  home.packages = with pkgs; [
    neovim
    ripgrep      # fzf-lua grep, your `grep` alias
    fd           # fzf-lua files, your `find` alias
    fzf          # fzf-lua needs the fzf binary
    tree-sitter  # nvim-treesitter parser compilation
    gnumake
    gcc          # compiles treesitter parsers at runtime (:TSInstall)
    unzip
    wget
    curl
  ];

  home.sessionVariables.EDITOR = "nvim";

  home.activation.linkNvimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run rm -rf $VERBOSE_ARG "${config.xdg.configHome}/nvim" \
      "${config.home.homeDirectory}/nix-config/dotfiles/nvim" \
      "${config.xdg.configHome}/nvim" \
  '';
}
