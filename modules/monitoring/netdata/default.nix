##
# Module: monitoring/netdata
# Purpose: Lightweight local Netdata with conservative resource limits.
# Key options: monitoring.netdata.enable
# Notes:
#  - Binds to default localhost-only via firewall; UI on http://127.0.0.1:19999
#  - Service is de-prioritized (nice/CPU/IO weights) to avoid game impact
{lib, config, pkgs, ...}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.monitoring.netdata;
in {
  options.monitoring.netdata.enable =
    mkEnableOption "Enable Netdata (lightweight, local-only UI)";

  config = mkIf cfg.enable {
    services.netdata = {
      enable = true;
      package = pkgs.netdata;
      # Keep defaults minimal; do not enable cloud/extra plugins here.
      # Users can extend via services.netdata.config in host overrides.
    };

    # Keep Netdata out of the way of games
    systemd.services.netdata = {
      serviceConfig = {
        Nice = 19;
        IOSchedulingClass = "idle";
        IOSchedulingPriority = 7;
        CPUWeight = 10;
        IOWeight = 10;
        # Keep memory bounded; Netdata defaults to low usage, but cap anyway
        MemoryMax = "256M";
        # Harden the service a bit
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        NoNewPrivileges = true;
        RestrictSUIDSGID = true;
        LockPersonality = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
      };
      # Ensure it starts after network
      after = ["network-online.target"];
      wants = ["network-online.target"];
    };

    # Do not expose port 19999 externally; allow via localhost only
    networking.firewall.allowedTCPPorts = lib.mkDefault [];
  };
}

