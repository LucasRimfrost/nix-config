{ ... }:
{
  imports = [
    ../modules/home/shell.nix
    ../modules/home/terminal.nix
    ../modules/home/editor.nix
    ../modules/home/browser.nix
    ../modules/home/theme.nix
  ];

  home.username = "lucas";
  home.homeDirectory = "/home/lucas";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
  xdg.enable = true;
}
