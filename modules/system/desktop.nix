{ pkgs, ... }:
{
  # ---- KDE Plasma 6 on Wayland ----
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Graphical-session keyboard layout (Plasma reads this default).
  # Change "us" -> "se" for a Swedish keyboard.
  services.xserver.xkb.layout = "se";

  # ---- Audio: PipeWire ----
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # ---- Input / laptop ----
  services.libinput.enable = true;

  # Power management that integrates with Plasma's battery UI.
  services.power-profiles-daemon.enable = true;
  powerManagement.enable = true;

  # ---- Printing + network discovery (handy; remove if you don't print) ----
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;

  # ---- Fonts ----
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
  ];

  # ---- Brave privacy policy (system-level; Brave reads /etc/brave/policies) ----
  environment.etc."brave/policies/managed/privacy.json".text = builtins.toJSON {
    BraveRewardsDisabled = true;
    BraveWalletDisabled = true;
    BraveVPNDisabled = true;
    BraveAIChatEnabled = false;
    MetricsReportingEnabled = false;
    BackgroundModeEnabled = false;
  };
}
