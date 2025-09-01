{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.servicesProfiles.wakapi;
in {
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [wakapi];
  };
}
