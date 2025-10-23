##
# Module: servers/adguardhome
# Purpose: AdGuardHome profile + DNS rewrite passthrough.
# Key options: cfg = config.servicesProfiles.adguardhome (enable, rewrites)
# Dependencies: May integrate with Unbound (upstream_dns).
{
  lib,
  config,
  ...
}: let
  cfg =
    config.servicesProfiles.adguardhome or {
      enable = false;
      rewrites = [];
      filterLists = [];
    };
in {
  config = lib.mkIf cfg.enable {
    services.adguardhome = {
      enable = true;
      openFirewall = true;
      # Bind the admin web UI away from :80 so Caddy can use it
      host = "127.0.0.1";
      port = 3000;
      # Make sure our Nix settings are honored strictly to avoid stale state conflicts
      mutableSettings = false;
      settings = {
        filtering = {
          protection_enabled = true;
          filtering_enabled = true;
          parental_enabled = false;
          safebrowsing_enabled = false;
          safe_search = { enabled = false; };
        };
        # Subscribe to upstream lists (if provided)
        filters = map (f: { inherit (f) name url enabled; }) cfg.filterLists;
        dns = {
          # Bind locally and serve on default DNS port.
          bind_host = "127.0.0.1";
          bind_hosts = ["127.0.0.1"]; # restrict to IPv4 localhost to avoid conflicts with libvirt/systemd-resolved
          ipv6 = false;
          port = 53;
          upstream_dns = ["127.0.0.1:5353"];
          bootstrap_dns = ["1.1.1.1" "8.8.8.8"];
          inherit (cfg) rewrites;
        };
      };
    };

    # Make systemd-resolved act as a stub resolver and forward to AdGuardHome
    # - dns = ["127.0.0.1"] forces forwarding to AdGuardHome on localhost:53
    # - fallbackDns = [] avoids bypassing AdGuard via system defaults
    # - domains = ["~."] ensures all lookups go through the configured DNS
    services.resolved = {
      enable = lib.mkDefault true;
      domains = ["~."];
      # Keep local resolver deterministic: disable LLMNR and mDNS broadcast resolution
      # (some NixOS releases expose these as explicit options; if not, extraConfig below handles it)
      llmnr = lib.mkDefault "false";
      extraConfig = lib.mkDefault ''
        LLMNR=no
        MulticastDNS=no
      '';
    };
    # Keep resolv.conf compatibility for tools that read networking.nameservers directly
    networking.nameservers = ["127.0.0.1"];
  };
}
