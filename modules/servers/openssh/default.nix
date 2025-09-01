{
  lib,
  config,
  ...
}: let
  cfg = (config.servicesProfiles.openssh or { enable = false; });
in {
  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };
    programs.mosh.enable = true; # Opens the relevant UDP ports.
  };
}
