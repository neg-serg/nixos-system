{
  lib,
  config,
  ...
}: let
  cfg = config.servicesProfiles.unbound;
in {
  config = lib.mkIf cfg.enable {
    services.unbound = {
      enable = true;
      settings = {
        server = {
          interface = ["127.0.0.1"];
          port = 5353;
          "do-tcp" = "yes";
          "do-udp" = "yes";
          verbosity = 1;
        };
      };
    };
  };
}
