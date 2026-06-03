{ ... }:
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
}
