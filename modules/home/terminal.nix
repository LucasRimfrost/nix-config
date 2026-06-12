{ pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = builtins.fromTOML (builtins.readFile ../../dotfiles/alacritty/alacritty.toml);
  };

  # ---- tmux (ported from your config) ----
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    baseIndex = 1;
    mouse = true;
    keyMode = "vi";
    terminal = "tmux-256color";
    escapeTime = 10;
    historyLimit = 50000;
    extraConfig = builtins.readFile ../../dotfiles/tmux/tmux-extra.conf;
  };

  home.packages = with pkgs; [
    wl-clipboard # wl-copy for the tmux yank binding (Wayland)
  ];
}
