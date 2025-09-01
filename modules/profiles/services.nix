{ lib, ... }:
{
  options.servicesProfiles = {
    adguardhome.enable = lib.mkEnableOption "AdGuard Home DNS with rewrites/profile wiring.";
    unbound.enable = lib.mkEnableOption "Unbound DNS resolver profile.";
    openssh.enable = lib.mkEnableOption "OpenSSH (and mosh) profile.";
    syncthing.enable = lib.mkEnableOption "Syncthing device sync profile.";
    mpd.enable = lib.mkEnableOption "MPD (Music Player Daemon) profile.";
    navidrome.enable = lib.mkEnableOption "Navidrome music server profile.";
    wakapi.enable = lib.mkEnableOption "Wakapi CLI tools profile.";
    nextcloud.enable = lib.mkEnableOption "Nextcloud server profile (with optional Caddy proxy).";
    avahi.enable = lib.mkEnableOption "Avahi (mDNS) profile.";
    jellyfin.enable = lib.mkEnableOption "Jellyfin media server profile.";
  };
}
