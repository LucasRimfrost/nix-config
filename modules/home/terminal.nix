{ pkgs, ... }:
{
  # ---- kitty ----
  # Your real kitty.conf (Rosé Pine Moon) is read verbatim so the tab templates,
  # powerline glyphs and emoji survive untouched. Edit dotfiles/kitty/kitty.conf
  # directly; no rebuild needed for kitty to pick it up (kitty_mod+f5 reloads).
  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ../../dotfiles/kitty/kitty.conf;
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
