{pkgs, lib, ...}: let
  gamescopePinned = pkgs.writeShellApplication {
    name = "gamescope-pinned";
    runtimeInputs = [pkgs.util-linux pkgs.gamescope pkgs.gamemode];
    text = ''
      set -euo pipefail
      CPUSET="${GAME_PIN_CPUSET:-14,15,30,31}"
      FLAGS="${GAMESCOPE_FLAGS:--f --adaptive-sync}"
      exec taskset -c "$CPUSET" gamemoderun gamescope $FLAGS -- "$@"
    '';
  };
  gamePinned = pkgs.writeShellApplication {
    name = "game-pinned";
    runtimeInputs = [pkgs.util-linux pkgs.gamemode];
    text = ''
      set -euo pipefail
      CPUSET="${GAME_PIN_CPUSET:-14,15,30,31}"
      exec taskset -c "$CPUSET" gamemoderun "$@"
    '';
  };
in {
  programs = {
    steam = {
      enable = true;
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
      # Add Proton-GE for better compatibility/perf in some titles
      extraCompatPackages = [pkgs.proton-ge-custom];
    };

    gamescope = {
      enable = true;
      package = pkgs.gamescope; # the default, here in case I want to override it
    };

    gamemode = {
      enable = true;
      enableRenice = true;
      settings = {
        general = {
          softrealtime = "on";
          # Negative values increase priority; -10 is a safe bump
          renice = -10;
        };
      };
    };

    # On-screen performance HUD (toggle via MANGOHUD=1)
    mangohud.enable = true;
  };

  environment.systemPackages = with pkgs; [
    protontricks
    gamescopePinned
    gamePinned
  ];

  security.wrappers.gamemode = {
    owner = "root";
    group = "root";
    source = "${pkgs.gamemode}/bin/gamemoderun";
    capabilities = "cap_sys_ptrace,cap_sys_nice+pie";
  };

  # Expose udev rules/devices used by various game controllers/VR etc
  hardware.steam-hardware.enable = true;
}
