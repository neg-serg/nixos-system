{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.servicesProfiles.wakapi;
in {
  options.servicesProfiles.wakapi.enable = lib.mkEnableOption "Wakapi CLI tools profile";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [wakapi];
  };
}
