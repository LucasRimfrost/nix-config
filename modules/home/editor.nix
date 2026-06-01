{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;  # most LSPs / plugins expect node
    withPython3 = true;
  };

  # Your existing ~/.config/nvim is symlinked to the live copy inside this repo
  # (NOT the read-only Nix store). This is deliberate: plugin managers like
  # lazy.nvim need to write lazy-lock.json into the config dir, and you can edit
  # your Lua without a rebuild. Drop your whole nvim/ folder into:
  #     ~/nix-config/dotfiles/nvim/
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nix-config/dotfiles/nvim";

  # Tools your config/LSPs commonly call on PATH.
  home.packages = with pkgs; [
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
}
