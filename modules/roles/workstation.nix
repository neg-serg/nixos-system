{
  lib,
  config,
  ...
}: let
  cfg = config.roles.workstation;
in {
  options.roles.workstation.enable = lib.mkEnableOption "Enable workstation role (desktop-first defaults).";

  config = lib.mkIf cfg.enable {
    # Favor performance on a desktop, but allow host overrides.
    profiles.performance.enable = lib.mkDefault true;

    # Common desktop-friendly services.
    servicesProfiles = {
      openssh.enable = lib.mkDefault true;
      avahi.enable = lib.mkDefault true;
      syncthing.enable = lib.mkDefault true;
    };
  };
}

