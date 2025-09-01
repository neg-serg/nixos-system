##
# Module: roles/media
# Purpose: Media role (Jellyfin/Navidrome/MPD etc).
# Key options: cfg = config.roles.media.enable
# Dependencies: Enables profiles.services.* (jellyfin, navidrome, mpd, avahi, openssh).
{
  lib,
  config,
  ...
}: let
  cfg = config.roles.media;
in {
  options.roles.media.enable = lib.mkEnableOption "Enable media role (media servers and discovery).";

  config = lib.mkIf cfg.enable {
    profiles.services = {
      jellyfin.enable = lib.mkDefault true;
      navidrome.enable = lib.mkDefault true;
      mpd.enable = lib.mkDefault true;
      avahi.enable = lib.mkDefault true;
      openssh.enable = lib.mkDefault true;
    };
  };
}
