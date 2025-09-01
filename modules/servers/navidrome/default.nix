{
  lib,
  config,
  ...
}: let
  cfg = config.servicesProfiles.navidrome;
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
