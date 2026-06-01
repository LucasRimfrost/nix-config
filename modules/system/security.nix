{ ... }:
{
  # ---- Kernel command-line hardening (conservative, well-tested set) ----
  boot.kernelParams = [
    "slab_nomerge"             # harder heap exploitation
    "init_on_alloc=1"          # zero memory on allocation
    "init_on_free=1"           # zero memory on free
    "page_alloc.shuffle=1"     # randomize page allocator freelists
    "randomize_kstack_offset=on"
    "vsyscall=none"            # remove legacy ROP target
    "debugfs=off"              # close a broad info-leak surface
  ];

  # ---- sysctl hardening ----
  boot.kernel.sysctl = {
    # Restrict kernel info leaks
    "kernel.kptr_restrict" = 2;
    "kernel.dmesg_restrict" = 1;
    "kernel.printk" = "3 3 3 3";
    # ptrace: a process can only trace its descendants
    "kernel.yama.ptrace_scope" = 1;
    # eBPF
    "kernel.unprivileged_bpf_disabled" = 1;
    "net.core.bpf_jit_harden" = 2;
    # Network spoofing / redirects
    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.tcp_syncookies" = 1;
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.secure_redirects" = 0;
    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv6.conf.all.accept_source_route" = 0;
    "net.ipv4.conf.all.log_martians" = 1;
    "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
  };

  # ---- Blacklist rarely-used network protocols (extra attack surface) ----
  # Deliberately does NOT blacklist filesystems, so your NTFS/exFAT/vfat USB
  # sticks keep working.
  boot.blacklistedKernelModules = [ "dccp" "sctp" "rds" "tipc" ];

  # ---- Mandatory access control ----
  security.apparmor.enable = true;

  # ---- sudo ----
  security.sudo.execWheelOnly = true; # only wheel members may use sudo

  # ---- KDE/Wayland needs polkit ----
  security.polkit.enable = true;

  # ---- Lock down the running kernel image; disables kexec + hibernation ----
  # (We aren't hibernating, so this is free hardening.)
  security.protectKernelImage = true;

  # ---- No coredumps (potential info leak) ----
  systemd.coredump.enable = false;

  # ---- Firmware updates (fwupd) ----
  services.fwupd.enable = true;
}
