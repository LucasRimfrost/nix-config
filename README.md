# Lucas's NixOS config

Reproducible NixOS 26.05 setup for a Lenovo ThinkPad X1 Yoga 3rd Gen
(20LGS07H00): KDE Plasma 6 (Wayland), full-disk LUKS2 encryption (Argon2id),
zram, hand-picked security/privacy hardening, and a home-manager environment
for zsh + kitty + tmux + Neovim + a Python/C·C++/Rust/Lua/Java/LaTeX dev stack.

## Layout

```
flake.nix              inputs (nixpkgs 26.05, home-manager, nixos-hardware) + outputs
hosts/lucas/           hardware-configuration.nix + default.nix (this machine)
modules/system/        boot, networking, security, nix, desktop
modules/home/          shell, terminal, editor, dev, browser
home/lucas.nix         home-manager entry point
dotfiles/kitty/        kitty.conf (read verbatim)
dotfiles/tmux/         tmux-extra.conf (read verbatim)
dotfiles/nvim/         your Neovim config (symlinked live) — see dotfiles/nvim/README.txt
```

================================================================================
## PART 0 — Prepare the USB stick (on your current Fedora laptop)
================================================================================

1. Download the ISO. Open https://nixos.org/download and grab the **GNOME/Plasma
   graphical ISO** for `x86_64` (any desktop ISO works; we install our own).
   You'll get something like `nixos-plasma6-26.05....iso`.

2. (Recommended) verify it:
   ```bash
   sha256sum ~/Downloads/nixos-*.iso
   ```
   Compare against the hash listed on the download page.

3. Find the USB device name. Insert the stick, then:
   ```bash
   lsblk -dpno NAME,SIZE,MODEL
   ```
   Identify your stick by size/model — e.g. `/dev/sdb`. **Triple-check this; the
   next step erases the target completely.**

4. Write the ISO (replace `/dev/sdX` with your stick, and note it's the whole
   disk, not a partition like `/dev/sdX1`):
   ```bash
   sudo dd if=~/Downloads/nixos-*.iso of=/dev/sdX bs=4M status=progress oflag=sync
   ```
   When it finishes: `sync`, then unplug.

   (Fedora's "Disks" GUI → ⋮ → "Restore Disk Image" also works if you prefer.)

5. Push this repo somewhere you can reach during install — easiest is to create
   a repo on GitHub/GitLab now and `git push` it, OR copy the `nix-config`
   folder onto a SECOND USB stick / the same stick's spare space.

================================================================================
## PART 1 — Boot the installer
================================================================================

1. Insert the USB, reboot, and open the boot menu (ThinkPad: tap **F12**).
2. Enter BIOS/UEFI (tap **Enter** then **F1**, or **F1** at power-on):
   - **Disable Secure Boot** (Security → Secure Boot → Disabled).
   - Confirm UEFI boot is on.
   - Save & exit.
3. Boot the NixOS USB. You'll land in a live desktop with a terminal.
4. Get online: click the network icon and join Wi-Fi (or use `nmtui`). Verify:
   ```bash
   ping -c2 nixos.org
   ```

================================================================================
## PART 2 — Partition, encrypt, mount  (ERASES /dev/nvme0n1)
================================================================================

> Back up anything important first. Confirm the disk name with `lsblk` — on this
> ThinkPad the NVMe is `/dev/nvme0n1`. All commands as root: `sudo -i`.

### Partition (UEFI / GPT): 1 GB EFI + rest for the encrypted root
```bash
parted /dev/nvme0n1 -- mklabel gpt
parted /dev/nvme0n1 -- mkpart ESP fat32 1MiB 1025MiB
parted /dev/nvme0n1 -- set 1 esp on
parted /dev/nvme0n1 -- mkpart cryptroot 1025MiB 100%
```
Now `p1` = EFI, `p2` = LUKS container.

### LUKS2 with Argon2id (strong, modern)
```bash
cryptsetup luksFormat --type luks2 \
  --cipher aes-xts-plain64 --key-size 512 --hash sha512 \
  --pbkdf argon2id --iter-time 5000 \
  /dev/nvme0n1p2
# Type YES, then set a STRONG passphrase. This is the only key to your disk.

cryptsetup open /dev/nvme0n1p2 cryptroot
```

### Filesystems + mount
```bash
mkfs.fat -F32 -n BOOT /dev/nvme0n1p1
mkfs.ext4 -L nixos /dev/mapper/cryptroot

mount /dev/mapper/cryptroot /mnt
mkdir -p /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
```

================================================================================
## PART 3 — Put the config in place
================================================================================

### Generate the hardware file
```bash
nixos-generate-config --root /mnt
```

### Get this repo to /mnt/home/lucas/nix-config
```bash
mkdir -p /mnt/home/lucas
# From git:
nix-shell -p git --run "git clone <your-repo-url> /mnt/home/lucas/nix-config"
# ...or copy it off your second USB stick (mount it, then cp -r).
```

### Drop in your Neovim config
Copy your whole nvim folder into `dotfiles/nvim/` and apply the 3 changes in
`dotfiles/nvim/README.txt` (replace lsp.lua + jdtls.lua with the ones provided,
and the one-line blink-cmp.lua edit).

### Wire in the two machine-specific values
```bash
blkid /dev/nvme0n1p2     # copy the UUID of the LUKS partition
```
- Edit `hosts/lucas/hardware-configuration.nix`: if it contains a
  `boot.initrd.luks.devices` block, **delete that block** (we declare LUKS once
  in `modules/system/boot.nix`).
- Move the generated hardware file into the repo, replacing the placeholder:
  ```bash
  cp /mnt/etc/nixos/hardware-configuration.nix \
     /mnt/home/lucas/nix-config/hosts/lucas/hardware-configuration.nix
  ```
- Edit `modules/system/boot.nix`: replace `REPLACE_WITH_LUKS_PARTITION_UUID`
  with the UUID from `blkid`.

(Edit with `nano` or `nix-shell -p neovim --run nvim`.)

### Fix ownership so the files are yours after reboot
```bash
chown -R 1000:100 /mnt/home/lucas
```

================================================================================
## PART 4 — Install
================================================================================
```bash
nixos-install --flake /mnt/home/lucas/nix-config#lucas
```
This pulls everything (incl. the large texliveFull — be patient). Set the
**root** password when prompted. Then set your user password:
```bash
nixos-enter --root /mnt -c 'passwd lucas'
```
Reboot and remove the USB:
```bash
reboot
```
At boot: enter your LUKS passphrase → SDDM → log into the **Plasma (Wayland)**
session. First Neovim launch bootstraps lazy.nvim and builds blink.cmp; give it
a minute.

================================================================================
## PART 5 — First steps + daily use
================================================================================
```bash
cd ~/nix-config
git init && git add -A && git commit -m "Initial NixOS config"   # if not already a repo
git remote add origin <your-repo-url> && git push -u origin main
```
Commit `flake.lock` — it pins exact versions and is what makes the build
reproducible. Never gitignore it.

Daily:
```bash
rebuild   # alias: sudo nixos-rebuild switch --flake ~/nix-config#lucas
update    # alias: bump flake.lock, then rebuild
```
Editing kitty/tmux/nvim configs needs no rebuild (they're live). Editing any
`.nix` file does → run `rebuild`.

**Rollback** if an update misbehaves: pick an older generation at the boot menu,
or `sudo nixos-rebuild switch --rollback`.

================================================================================
## PART 6 — A future laptop
================================================================================
1. Boot installer; do PART 2 (partition/LUKS/mount).
2. `git clone <your-repo-url> /mnt/home/lucas/nix-config`
3. `cp hosts/lucas` → `hosts/<newname>`, drop in that machine's generated
   `hardware-configuration.nix`, fix the LUKS UUID, add a
   `nixosConfigurations.<newname>` block in `flake.nix`.
4. `nixos-install --flake /mnt/home/lucas/nix-config#<newname>`

Same apps, same hardening, reproduced.

================================================================================
## Notes / tradeoffs
================================================================================
- **KDE Plasma 6** (lighter than GNOME on 8 GB; best fractional scaling).
- **zram, no hibernation** — simpler, avoids resume bugs.
- **ext4 on LUKS2** — rollback already comes from NixOS generations.
- **Quad9 DNS-over-TLS**, all lookups encrypted; can block captive portals (see
  networking.nix for the toggle).
- **Hardening is hand-picked**, not the upstream `hardened` profile (which
  breaks things). USB filesystems left unblocked so NTFS/exFAT sticks work.
- **No Mason / no rustup / no nvm / no tlmgr** — all replaced by Nix-provided
  tools, because each downloads FHS binaries that don't run on NixOS.
- **8 GB RAM** with Plasma + Brave + LSPs will be tight; zram helps but expect
  pressure under heavy multitasking. Not a config bug — the hardware.
