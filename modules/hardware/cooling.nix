{ lib, pkgs, config, ... }:
let
  cfg = config.hardware.cooling or {};
in {
  options.hardware.cooling = {
    enable = lib.mkEnableOption "Enable cooling stack (sensors + optional fancontrol).";

    loadNct6775 = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Load the Nuvoton/ASUS Super I/O PWM driver (nct6775) for motherboard fan control.";
    };

    autoFancontrol = {
      enable = lib.mkEnableOption "Autogenerate /etc/fancontrol at boot with a conservative quiet profile.";

      minTemp = lib.mkOption {
        type = lib.types.int;
        default = 35;
        description = "Temperature (°C) where fans start ramping (quiet).";
      };
      maxTemp = lib.mkOption {
        type = lib.types.int;
        default = 75;
        description = "Temperature (°C) for max fan speed.";
      };
      minPwm = lib.mkOption {
        type = lib.types.int;
        default = 70;
        description = "Minimum PWM value (0–255) to avoid fan stall (quiet).";
      };
      maxPwm = lib.mkOption {
        type = lib.types.int;
        default = 255;
        description = "Maximum PWM value (0–255).";
      };
      hysteresis = lib.mkOption {
        type = lib.types.int;
        default = 3;
        description = "Hysteresis (°C) for fancontrol transitions.";
      };
      interval = lib.mkOption {
        type = lib.types.int;
        default = 2;
        description = "Polling interval (seconds).";
      };
    };

    gpuFancontrol = {
      enable = lib.mkEnableOption "Include AMDGPU fan (pwm1) in the generated fancontrol profile (manual control).";
      # Safer, quiet defaults for GPU
      minTemp = lib.mkOption {
        type = lib.types.int;
        default = 50;
        description = "GPU temperature (°C) to start ramping.";
      };
      maxTemp = lib.mkOption {
        type = lib.types.int;
        default = 85;
        description = "GPU temperature (°C) for max fan speed.";
      };
      minPwm = lib.mkOption {
        type = lib.types.int;
        default = 70;
        description = "GPU minimum PWM (0–255) to avoid stall while staying quiet.";
      };
      maxPwm = lib.mkOption {
        type = lib.types.int;
        default = 255;
        description = "GPU maximum PWM (0–255).";
      };
      hysteresis = lib.mkOption {
        type = lib.types.int;
        default = 3;
        description = "GPU fancontrol hysteresis (°C).";
      };
    };
  };

  config = lib.mkIf (cfg.enable or false) {
    # Load the typical motherboard PWM driver (Nuvoton/ASUS)
    boot.kernelModules = lib.mkIf cfg.loadNct6775 [ "nct6775" ];

    # Autogenerate a quiet fan profile if requested
    systemd.services.fancontrol-setup = lib.mkIf (cfg.autoFancontrol.enable or false) {
      description = "Generate quiet /etc/fancontrol from detected hwmon devices";
      after = [ "multi-user.target" ];
      before = [ "fancontrol.service" ];
      wantedBy = [ "fancontrol.service" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = let
          script = pkgs.writeShellScript "fancontrol-setup" (builtins.readFile ../../scripts/fancontrol-setup.sh);
        in "${script}";
        Environment = [
          "MIN_TEMP=${builtins.toString cfg.autoFancontrol.minTemp}"
          "MAX_TEMP=${builtins.toString cfg.autoFancontrol.maxTemp}"
          "MIN_PWM=${builtins.toString cfg.autoFancontrol.minPwm}"
          "MAX_PWM=${builtins.toString cfg.autoFancontrol.maxPwm}"
          "HYST=${builtins.toString cfg.autoFancontrol.hysteresis}"
          "INTERVAL=${builtins.toString cfg.autoFancontrol.interval}"
          "GPU_ENABLE=${lib.boolToString (cfg.gpuFancontrol.enable or false)}"
          "GPU_MIN_TEMP=${builtins.toString cfg.gpuFancontrol.minTemp}"
          "GPU_MAX_TEMP=${builtins.toString cfg.gpuFancontrol.maxTemp}"
          "GPU_MIN_PWM=${builtins.toString cfg.gpuFancontrol.minPwm}"
          "GPU_MAX_PWM=${builtins.toString cfg.gpuFancontrol.maxPwm}"
          "GPU_HYST=${builtins.toString cfg.gpuFancontrol.hysteresis}"
        ];
        RemainAfterExit = true;
      };
    };

    # Fancontrol service (runs the binary from lm_sensors)
    systemd.services.fancontrol = lib.mkIf (cfg.autoFancontrol.enable or false) {
      description = "Software fan speed control (fancontrol)";
      requires = [ "fancontrol-setup.service" ];
      after = [ "fancontrol-setup.service" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.lm_sensors}/bin/fancontrol";
        Restart = "on-failure";
        RestartSec = 5;
        # Only start if config exists
        ConditionPathExists = "/etc/fancontrol";
      };
      wantedBy = [ "multi-user.target" ];
    };

    # Re-apply manual PWM ownership after suspend/hibernate resume
    # (amdgpu and some motherboard controllers reset pwm*_enable to automatic)
    environment.etc."systemd/system-sleep/99-fancontrol-reapply" = lib.mkIf (cfg.autoFancontrol.enable or false) {
      source = let
        txt = builtins.replaceStrings ["@GPU_ENABLE@"] [ (lib.boolToString (cfg.gpuFancontrol.enable or false)) ]
          (builtins.readFile ../../scripts/fancontrol-reapply.sh);
      in pkgs.writeShellScript "fancontrol-reapply" txt;
      mode = "0755";
    };

    # Ensure tools are present for manual inspection/tweaks
    environment.systemPackages = [ pkgs.lm_sensors ];
  };
}
