{
  lib,
  config,
  ...
}: let
  hasSynSecret = builtins.pathExists (../../.. + "/secrets/syncthing.sops.yaml");
  cfg = (config.servicesProfiles.syncthing or { enable = false; });
in {
  config = lib.mkIf cfg.enable {
    # Register secret only if present to keep evaluation robust without secrets
    sops.secrets."syncthing/gui-pass" = lib.mkIf hasSynSecret {
      sopsFile = ../../../secrets/syncthing.sops.yaml;
    };

    services.syncthing = {
      enable = true;
      user = "neg";
      settings.gui = {
        user = "neg";
        # Password is managed out-of-band (either already configured in Syncthing
        # or updated manually via GUI/API). Avoid reading secrets at eval time.
      };
      dataDir = "/zero/syncthing/data";
      configDir = "/zero/syncthing/config";
      # Devices and folders moved to hosts/* to avoid host-specific settings in common module.
    };
    # Syncthing ports: 8384 for remote access to GUI
    # 22000 TCP and/or UDP for sync traffic
    # 21027/UDP for discovery
    # source: https://docs.syncthing.net/users/firewall.html
    networking.firewall.allowedTCPPorts = [8384 22000];
    networking.firewall.allowedUDPPorts = [22000 21027];
  };
}
