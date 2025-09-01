##
# Module: servers/wakapi
# Purpose: Wakapi CLI tools profile.
# Key options: cfg = config.servicesProfiles.wakapi.enable
# Dependencies: pkgs.wakapi (CLI).
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
