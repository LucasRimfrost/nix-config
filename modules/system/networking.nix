{ ... }:
{
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "systemd-resolved";

  # Per-network stable-random MAC (privacy without breaking MAC-allowlist networks).
  networking.networkmanager.wifi.macAddress = "stable";

  # ---- Firewall: nftables backend, default-deny inbound ----
  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    allowPing = false;
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
  };

  # ---- Encrypted DNS via Quad9 (DNS-over-TLS) ----
  # Privacy-first, non-profit, Swiss, with malware filtering + DNSSEC.
  # To use Cloudflare instead, swap the IPs for 1.1.1.1/1.0.0.1#cloudflare-dns.com.
  services.resolved = {
    enable = true;
    # "allow-downgrade" avoids breakage on misconfigured/captive networks while
    # still validating where possible. Use "true" for strict DNSSEC.
    dnssec = "allow-downgrade";
    dnsovertls = "true";
    domains = [ "~." ]; # route ALL lookups through our servers (ignore DHCP-pushed DNS)
    fallbackDns = [
      "9.9.9.9#dns.quad9.net"
      "2620:fe::fe#dns.quad9.net"
    ];
    extraConfig = ''
      DNS=9.9.9.9#dns.quad9.net 149.112.112.112#dns.quad9.net 2620:fe::fe#dns.quad9.net 2620:fe::9#dns.quad9.net
    '';
  };

  # NOTE: strict DNS-over-TLS can block captive-portal login pages (hotels,
  # airports). If you get stuck on one, temporarily set dnsovertls = "false",
  # rebuild, log in, then revert.
}
