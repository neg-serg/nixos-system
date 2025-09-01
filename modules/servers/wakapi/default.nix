{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = (config.servicesProfiles.wakapi or { enable = false; });
in {
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [wakapi];
  };
}
