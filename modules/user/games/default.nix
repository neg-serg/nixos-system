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

  # Preset launchers around gamescope-pinned with common flags
  gamescopePerf = pkgs.writeShellApplication {
    name = "gamescope-perf";
    runtimeInputs = [pkgs.util-linux pkgs.gamescope pkgs.gamemode pkgs.zenity];
    text = ''
      set -euo pipefail
      CPUSET="${GAME_PIN_CPUSET:-14,15,30,31}"
      OUT_W="${GAMESCOPE_OUT_W:-3840}"; OUT_H="${GAMESCOPE_OUT_H:-2160}"
      GAME_W="${GAMESCOPE_GAME_W:-2560}"; GAME_H="${GAMESCOPE_GAME_H:-1440}"
      FLAGS="-f --adaptive-sync -w ${GAME_W} -h ${GAME_H} -W ${OUT_W} -H ${OUT_H} --fsr-sharpness 3"
      if [ "$#" -eq 0 ]; then
        CMD=$(zenity --entry --title="Gamescope Performance" --text="Command to run:" || true)
        [ -z "${CMD:-}" ] && exit 0
        exec taskset -c "$CPUSET" gamemoderun gamescope $FLAGS -- bash -lc "$CMD"
      else
        exec taskset -c "$CPUSET" gamemoderun gamescope $FLAGS -- "$@"
      fi
    '';
  };

  gamescopeQuality = pkgs.writeShellApplication {
    name = "gamescope-quality";
    runtimeInputs = [pkgs.util-linux pkgs.gamescope pkgs.gamemode pkgs.zenity];
    text = ''
      set -euo pipefail
      CPUSET="${GAME_PIN_CPUSET:-14,15,30,31}"
      OUT_W="${GAMESCOPE_OUT_W:-3840}"; OUT_H="${GAMESCOPE_OUT_H:-2160}"
      FLAGS="-f --adaptive-sync -W ${OUT_W} -H ${OUT_H}"
      if [ "$#" -eq 0 ]; then
        CMD=$(zenity --entry --title="Gamescope Quality" --text="Command to run:" || true)
        [ -z "${CMD:-}" ] && exit 0
        exec taskset -c "$CPUSET" gamemoderun gamescope $FLAGS -- bash -lc "$CMD"
      else
        exec taskset -c "$CPUSET" gamemoderun gamescope $FLAGS -- "$@"
      fi
    '';
  };

  gamescopeHDR = pkgs.writeShellApplication {
    name = "gamescope-hdr";
    runtimeInputs = [pkgs.util-linux pkgs.gamescope pkgs.gamemode pkgs.zenity];
    text = ''
      set -euo pipefail
      CPUSET="${GAME_PIN_CPUSET:-14,15,30,31}"
      OUT_W="${GAMESCOPE_OUT_W:-3840}"; OUT_H="${GAMESCOPE_OUT_H:-2160}"
      FLAGS="-f --adaptive-sync --hdr-enabled -W ${OUT_W} -H ${OUT_H}"
      if [ "$#" -eq 0 ]; then
        CMD=$(zenity --entry --title="Gamescope HDR" --text="Command to run:" || true)
        [ -z "${CMD:-}" ] && exit 0
        exec taskset -c "$CPUSET" gamemoderun gamescope $FLAGS -- bash -lc "$CMD"
      else
        exec taskset -c "$CPUSET" gamemoderun gamescope $FLAGS -- "$@"
      fi
    '';
  };

  # Desktop entries for convenient launchers
  gamescopePerfDesktop = pkgs.makeDesktopItem {
    name = "gamescope-perf";
    desktopName = "Gamescope (Performance)";
    comment = "Run a command via Gamescope with FSR downscale (2560x1440→3840x2160) and CPU pinning";
    exec = "gamescope-perf";
    terminal = false;
    categories = ["Game" "Utility"];
  };
  gamescopeQualityDesktop = pkgs.makeDesktopItem {
    name = "gamescope-quality";
    desktopName = "Gamescope (Quality)";
    comment = "Run a command via Gamescope at native resolution with CPU pinning";
    exec = "gamescope-quality";
    terminal = false;
    categories = ["Game" "Utility"];
  };
  gamescopeHDRDesktop = pkgs.makeDesktopItem {
    name = "gamescope-hdr";
    desktopName = "Gamescope (HDR)";
    comment = "Run a command via Gamescope with HDR enabled and CPU pinning";
    exec = "gamescope-hdr";
    terminal = false;
    categories = ["Game" "Utility"];
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
    gamescopePerf
    gamescopeQuality
    gamescopeHDR
    gamescopePerfDesktop
    gamescopeQualityDesktop
    gamescopeHDRDesktop
  ];

  # System-wide MangoHud defaults
  environment.etc."xdg/MangoHud/MangoHud.conf".text = ''
    legacy_layout=0
    position=top-left
    font_size=20
    background_alpha=0.35
    toggle_hud=Shift_R+F12
    toggle_logging=Shift_L+F2
    toggle_fps_limit=Shift_L+F1

    fps=1
    frametime=1
    frame_timing=1
    gpu_stats=1
    cpu_stats=1
    gpu_temp=1
    cpu_temp=1
    vram=1
    ram=1
    io_read=1
    io_write=1
    gamemode=1
  '';

  security.wrappers.gamemode = {
    owner = "root";
    group = "root";
    source = "${pkgs.gamemode}/bin/gamemoderun";
    capabilities = "cap_sys_ptrace,cap_sys_nice+pie";
  };

  # Expose udev rules/devices used by various game controllers/VR etc
  hardware.steam-hardware.enable = true;
}
