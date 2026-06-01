# ============================================================================
# PLACEHOLDER — DO NOT USE AS-IS.
#
# During installation you run:
#     sudo nixos-generate-config --root /mnt
# which writes a REAL hardware-configuration.nix detecting your actual disks,
# UUIDs and kernel modules. Copy that generated file over THIS one:
#     cp /mnt/etc/nixos/hardware-configuration.nix \
#        /mnt/home/lucas/nix-config/hosts/lucas/hardware-configuration.nix
#
# IMPORTANT: if the generated file contains a `boot.initrd.luks.devices`
# block, DELETE it here — the LUKS device is declared once in
# modules/system/boot.nix to keep it under version control. Declaring it in
# both places causes an evaluation conflict.
# ============================================================================
{ ... }:
{
  # This stub lets the flake evaluate before you generate the real file.
  # It will be overwritten during install.
}
