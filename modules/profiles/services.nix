{ lib, ... }:
let
  mk = name: desc: {
    options.servicesProfiles.${name}.enable = lib.mkEnableOption desc;
  };
in
  lib.mkMerge [
    (mk "adguardhome" "AdGuard Home DNS with rewrites/profile wiring.")
    (mk "unbound" "Unbound DNS resolver profile.")
    (mk "openssh" "OpenSSH (and mosh) profile.")
    (mk "syncthing" "Syncthing device sync profile.")
    (mk "mpd" "MPD (Music Player Daemon) profile.")
    (mk "navidrome" "Navidrome music server profile.")
    (mk "wakapi" "Wakapi CLI tools profile.")
    (mk "nextcloud" "Nextcloud server profile (with optional Caddy proxy).")
    (mk "avahi" "Avahi (mDNS) profile.")
    (mk "jellyfin" "Jellyfin media server profile.")
  ]

