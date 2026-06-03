{ pkgs, ... }:
{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    trusted-users = [ "root" "lucas" ];
  };

  # Automatic garbage collection — keep 2 weeks of history.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Deduplicate the store on a timer too.
  nix.optimise.automatic = true;

  # Brave (and a couple of firmware blobs) are unfree.
  nixpkgs.config.allowUnfree = true;

  documentation.dev.enable = true;

  # Linux man-pages project: section 2/3 pages (getaddrinfo, open(2), printf(3), …)
  environment.systemPackages = with pkgs; [
    man-pages
    man-pages-posix
  ];

  # Build the apropos/whatis index so `man -k` and `apropos getaddrinfo` work too.
  documentation.man.generateCaches = true;
}
