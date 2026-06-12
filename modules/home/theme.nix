{ pkgs, ... }:
{
  # Theme files must exist on disk before Plasma can select them.
  home.packages = with pkgs; [
    bibata-cursors   # provides Bibata-Modern-Ice (and the other Bibata variants)
    tela-icon-theme  # provides Tela, Tela-dark, Tela-light + color variants
  ];

  # ---- KDE Plasma (via plasma-manager) ----
  programs.plasma = {
    enable = true;
    workspace = {
      cursor = {
        theme = "Bibata-Modern-Ice";
        size = 24;
      };
      iconTheme = "Tela"; # variants: "Tela-dark", "Tela-light", "Tela-blue-dark", ...
    };
  };

  # ---- Cursor for non-KDE apps (GTK, Electron, etc.) ----
  # Keeps the pointer consistent outside Plasma's own windows.
  home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
  };
}
