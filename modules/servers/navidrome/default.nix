##
# Module: servers/navidrome
# Purpose: Navidrome music server profile.
# Key options: cfg = config.servicesProfiles.navidrome.enable
# Dependencies: pkgs.navidrome; music library path.
{
  lib,
  config,
  ...
}: let
  cfg = config.servicesProfiles.navidrome or {enable = false;};
in {
  config = lib.mkIf cfg.enable {
    services.navidrome = {
      enable = true;
      openFirewall = true;
      settings = {
        MusicFolder = "/one/music";
      };
    };
  };
}
