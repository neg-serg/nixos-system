{
  lib,
  config,
  ...
}: let
  cfg = config.servicesProfiles.navidrome;
in {
  options.servicesProfiles.navidrome.enable = lib.mkEnableOption "Navidrome music server profile";

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
