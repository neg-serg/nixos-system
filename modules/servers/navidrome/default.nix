{
  lib,
  config,
  ...
}: let
  cfg = (config.servicesProfiles.navidrome or { enable = false; });
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
