{ pkgs, ... }:
{
  home.packages = [ pkgs.brave ];

  # Brave's telemetry/rewards/wallet/VPN/AI are disabled via a managed policy
  # declared in modules/system/desktop.nix (Linux reads /etc/brave/policies).
}
