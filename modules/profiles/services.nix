{ lib, ... }:
let
  inherit (lib) mkEnableOption mkOption types;
in {
  options.servicesProfiles = {
    adguardhome = {
      enable = mkEnableOption "AdGuard Home DNS with rewrites/profile wiring.";
      rewrites = mkOption {
        type = types.listOf (types.submodule (_: {
          options = {
            domain = mkOption {
              type = types.str;
              description = "Domain to rewrite";
            };
            answer = mkOption {
              type = types.str;
              description = "Rewrite answer (IP or hostname)";
            };
          };
        }));
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
    unbound.enable = mkEnableOption "Unbound DNS resolver profile.";
    openssh.enable = mkEnableOption "OpenSSH (and mosh) profile.";
    syncthing.enable = mkEnableOption "Syncthing device sync profile.";
    mpd.enable = mkEnableOption "MPD (Music Player Daemon) profile.";
    navidrome.enable = mkEnableOption "Navidrome music server profile.";
    wakapi.enable = mkEnableOption "Wakapi CLI tools profile.";
    nextcloud.enable = mkEnableOption "Nextcloud server profile (with optional Caddy proxy).";
    avahi.enable = mkEnableOption "Avahi (mDNS) profile.";
    jellyfin.enable = mkEnableOption "Jellyfin media server profile.";
  };
}
