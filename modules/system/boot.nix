{ ... }:
{
  # ---- Bootloader: systemd-boot (UEFI), Secure Boot off ----
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10; # keep last 10 generations in the menu
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 3;

  # Default NixOS kernel = best-tested = most stable.
  # For newer hardware support you could switch to pkgs.linuxPackages_latest.
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  # systemd-based initrd (the default on 26.05) — robust LUKS handling.
  boot.initrd.systemd.enable = true;

  # ---- LUKS2 root unlock ----
  # Fill in the UUID of your *encrypted partition* (the LUKS container itself,
  # e.g. /dev/nvme0n1p2), found with: blkid /dev/nvme0n1p2
  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-uuid/REPLACE_WITH_LUKS_PARTITION_UUID";
    allowDiscards = true;    # SSD TRIM passthrough (tiny info-leak tradeoff, fine on a laptop)
    bypassWorkqueues = true; # better SSD throughput
  };
}
