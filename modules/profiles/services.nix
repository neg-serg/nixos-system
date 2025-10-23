##
# Module: profiles/services
# Purpose: Central registry of profiles.services.* options (alias servicesProfiles.*).
# Key options: cfg = config.servicesProfiles.<service> (enable and service-specific settings).
# Dependencies: Referenced by service modules under modules/servers/*.
{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) types;
  opts = import ../../lib/opts.nix {inherit lib;};
in {
  options.servicesProfiles = {
    adguardhome = {
      enable = opts.mkEnableOption "AdGuard Home DNS with rewrites/profile wiring.";
      # Optional filter list catalog to be written into AdGuardHome.yaml
      filterLists =
        opts.mkListOpt (types.submodule (_: {
          options = {
            name = opts.mkStrOpt { description = "Human-friendly filter list name"; };
            url = opts.mkStrOpt { description = "URL to the filter list"; };
            enabled = opts.mkBoolOpt { default = true; description = "Enable this list"; };
          };
        })) {
          default = [];
          description = "List of upstream filter lists for AdGuardHome.";
          example = [
            {
              name = "AdGuard DNS filter";
              url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
            }
          ];
        };
      rewrites =
        opts.mkListOpt (types.submodule (_: {
          options = {
            domain = opts.mkStrOpt {description = "Domain to rewrite";};
            answer = opts.mkStrOpt {description = "Rewrite answer (IP or hostname)";};
          };
        })) {
          default = [];
          description = "List of DNS rewrite rules for AdGuard Home.";
          example = [
            {
              domain = "nas.local";
              answer = "192.168.1.10";
            }
          ];
        };
    };
    bitcoind = {
      enable = opts.mkEnableOption "Bitcoin Core node profile with a custom data directory.";
      instance = opts.mkStrOpt {
        default = "main";
        description = "Instance name used under services.bitcoind.<name>.";
        notes = "The resulting systemd unit runs as bitcoind-<name>.";
      };
      dataDir = opts.mkStrOpt {
        default = "/zero/bitcoin-node";
        description = "Filesystem path for the Bitcoin Core data directory.";
        notes = "The directory is created automatically with the correct ownership when the profile is enabled.";
      };
      p2pPort = opts.mkIntOpt {
        default = 8333;
        description = "TCP port to expose for Bitcoin peer-to-peer traffic.";
        notes = "Set this to 18333 for testnet or another value if you override the service port.";
      };
    };
    unbound = {
      enable = opts.mkEnableOption "Unbound DNS resolver profile.";
      mode = opts.mkEnumOpt ["recursive" "dot" "doh"] {
        default = "dot";
        description = "How Unbound fetches upstream DNS: direct recursion, DNS-over-TLS, or via DoH proxy.";
      };
      dnssec = {
        enable = opts.mkBoolOpt { default = true; description = "Enable DNSSEC validation in Unbound."; };
      };
      dotUpstreams = opts.mkListOpt types.str {
        default = [
          "1.1.1.1@853#cloudflare-dns.com"
          "1.0.0.1@853#cloudflare-dns.com"
          "9.9.9.9@853#dns.quad9.net"
          "149.112.112.112@853#dns.quad9.net"
        ];
        description = "List of DoT forwarders in host@port#SNI format.";
      };
      doh = {
        listenAddress = opts.mkStrOpt {
          default = "127.0.0.1:5053";
          description = "Local address where dnscrypt-proxy2 (DoH proxy) listens.";
        };
        serverNames = opts.mkListOpt types.str {
          default = ["cloudflare" "quad9-doh"];
          description = "dnscrypt-proxy2 server_names to use for DoH.";
        };
        ipv6Servers = opts.mkBoolOpt {
          default = false;
          description = "Allow IPv6 upstream servers in dnscrypt-proxy2.";
        };
        requireDnssec = opts.mkBoolOpt {
          default = true;
          description = "Require DNSSEC-capable upstreams in dnscrypt-proxy2.";
        };
        sources = opts.mkOpt types.attrs {} {
          description = "Optional dnscrypt-proxy2 sources object to override default public-resolvers.";
          example = {
            public-resolvers = {
              urls = [
                "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
                "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
              ];
              cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
            };
          };
        };
      };
    };
    openssh.enable = opts.mkEnableOption "OpenSSH (and mosh) profile.";
    syncthing.enable = opts.mkEnableOption "Syncthing device sync profile.";
    mpd.enable = opts.mkEnableOption "MPD (Music Player Daemon) profile.";
    navidrome.enable = opts.mkEnableOption "Navidrome music server profile.";
    wakapi.enable = opts.mkEnableOption "Wakapi CLI tools profile.";
    nextcloud = {
      enable = opts.mkEnableOption "Nextcloud server profile (with optional Caddy proxy).";
      package = opts.mkOpt (types.nullOr types.package) null {
        description = ''
          Nextcloud package derivation to use for the service.
          Set to a specific `pkgs.nextcloudXX` or a flake-provided package to pin the major version.
          When unset, the module uses a sensible default from `pkgs` (currently Nextcloud 31).
        '';
        example = pkgs.nextcloud31;
      };
    };
    avahi.enable = opts.mkEnableOption "Avahi (mDNS) profile.";
    jellyfin.enable = opts.mkEnableOption "Jellyfin media server profile.";
    samba.enable = opts.mkEnableOption "Samba (SMB/CIFS) fileshare profile.";
  };
}
