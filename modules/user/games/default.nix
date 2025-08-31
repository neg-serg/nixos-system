{pkgs, lib, config, ...}: let
  cfg = config.profiles.games or {};
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
    runtimeInputs = [pkgs.util-linux pkgs.gamescope pkgs.gamemode pkgs.zenity pkgs.jq pkgs.gawk];
    text = ''
      set -euo pipefail
      CPUSET="${GAME_PIN_CPUSET:-14,15,30,31}"
      MON="${GAMESCOPE_MON:-}"
      # Detect current monitor resolution via Hyprland; fallback to 3840x2160
      OUT_W="${GAMESCOPE_OUT_W:-}"
      OUT_H="${GAMESCOPE_OUT_H:-}"
      if [ -z "${OUT_W}" ] || [ -z "${OUT_H}" ]; then
        if command -v hyprctl >/dev/null 2>&1; then
          JSON=$(hyprctl monitors -j 2>/dev/null || true)
          if [ -n "${JSON}" ]; then
            # If no monitor specified, pick the best one: highest refresh, then highest resolution
            if [ -z "${MON}" ]; then
              BEST=$(printf '%s' "$JSON" | jq -r 'sort_by([.refreshRate, (.width // 0) * (.height // 0)]) | reverse | .[0].name // empty')
              [ -n "${BEST}" ] && MON="${BEST}"
            fi
            if [ -n "${MON}" ]; then
              W=$(printf '%s' "$JSON" | MON="$MON" jq -r 'map(select(.name==env.MON)) | .[0].width // empty')
              H=$(printf '%s' "$JSON" | MON="$MON" jq -r 'map(select(.name==env.MON)) | .[0].height // empty')
            else
              W=$(printf '%s' "$JSON" | jq -r 'map(select(.focused==true)) | .[0].width // empty')
              H=$(printf '%s' "$JSON" | jq -r 'map(select(.focused==true)) | .[0].height // empty')
            fi
            if [ -n "${W}" ] && [ -n "${H}" ]; then
              OUT_W=${OUT_W:-$W}
              OUT_H=${OUT_H:-$H}
            fi
          fi
        fi
      fi
      OUT_W="${OUT_W:-3840}"; OUT_H="${OUT_H:-2160}"
      # Optional: focus the target monitor so gamescope opens there
      if [ -n "${MON}" ] && command -v hyprctl >/dev/null 2>&1; then
        hyprctl dispatch focusmonitor "${MON}" >/dev/null 2>&1 || true
      fi
      # Choose refresh rate: explicit env overrides autodetect
      RATE="${GAMESCOPE_RATE:-}"
      if [ -z "${RATE}" ] && command -v hyprctl >/dev/null 2>&1; then
        JSON=${JSON:-""}
        if [ -z "${JSON}" ]; then JSON=$(hyprctl monitors -j 2>/dev/null || true); fi
        if [ -n "${JSON}" ]; then
          if [ -n "${MON}" ]; then
            RR=$(printf '%s' "$JSON" | MON="$MON" jq -r 'map(select(.name==env.MON)) | .[0].refreshRate // empty')
          else
            RR=$(printf '%s' "$JSON" | jq -r 'map(select(.focused==true)) | .[0].refreshRate // empty')
          fi
          if [ -n "${RR}" ] && [ "${RR}" != "null" ]; then
            RATE=$(awk -v r="$RR" 'BEGIN{ printf("%d", (r<1)?0:int(r+0.5)) }')
          fi
        fi
      fi
      RATEFLAG=""; [ -n "${RATE}" ] && RATEFLAG="-r ${RATE}"
      # Default game render scale ≈ 0.66 of output for performance
      GAME_W="${GAMESCOPE_GAME_W:-}"
      GAME_H="${GAMESCOPE_GAME_H:-}"
      if [ -z "${GAME_W}" ] || [ -z "${GAME_H}" ]; then
        GAME_W=$(awk -v w="$OUT_W" 'BEGIN{ printf("%d", w*2/3) }')
        GAME_H=$(awk -v h="$OUT_H" 'BEGIN{ printf("%d", h*2/3) }')
      fi
      FLAGS="-f --adaptive-sync ${RATEFLAG} -w ${GAME_W} -h ${GAME_H} -W ${OUT_W} -H ${OUT_H} --fsr-sharpness 3"
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
    runtimeInputs = [pkgs.util-linux pkgs.gamescope pkgs.gamemode pkgs.zenity pkgs.jq];
    text = ''
      set -euo pipefail
      CPUSET="${GAME_PIN_CPUSET:-14,15,30,31}"
      MON="${GAMESCOPE_MON:-}"
      OUT_W="${GAMESCOPE_OUT_W:-}"; OUT_H="${GAMESCOPE_OUT_H:-}"
      if [ -z "${OUT_W}" ] || [ -z "${OUT_H}" ]; then
        if command -v hyprctl >/dev/null 2>&1; then
          JSON=$(hyprctl monitors -j 2>/dev/null || true)
          if [ -n "${JSON}" ]; then
            if [ -z "${MON}" ]; then
              BEST=$(printf '%s' "$JSON" | jq -r 'sort_by([.refreshRate, (.width // 0) * (.height // 0)]) | reverse | .[0].name // empty')
              [ -n "${BEST}" ] && MON="${BEST}"
            fi
            if [ -n "${MON}" ]; then
              W=$(printf '%s' "$JSON" | MON="$MON" jq -r 'map(select(.name==env.MON)) | .[0].width // empty')
              H=$(printf '%s' "$JSON" | MON="$MON" jq -r 'map(select(.name==env.MON)) | .[0].height // empty')
            else
              W=$(printf '%s' "$JSON" | jq -r 'map(select(.focused==true)) | .[0].width // empty')
              H=$(printf '%s' "$JSON" | jq -r 'map(select(.focused==true)) | .[0].height // empty')
            fi
            if [ -n "${W}" ] && [ -n "${H}" ]; then
              OUT_W=${OUT_W:-$W}
              OUT_H=${OUT_H:-$H}
            fi
          fi
        fi
      fi
      OUT_W="${OUT_W:-3840}"; OUT_H="${OUT_H:-2160}"
      if [ -n "${MON}" ] && command -v hyprctl >/dev/null 2>&1; then
        hyprctl dispatch focusmonitor "${MON}" >/dev/null 2>&1 || true
      fi
      RATE="${GAMESCOPE_RATE:-}"
      if [ -z "${RATE}" ] && command -v hyprctl >/dev/null 2>&1; then
        JSON=${JSON:-""}
        if [ -z "${JSON}" ]; then JSON=$(hyprctl monitors -j 2>/dev/null || true); fi
        if [ -n "${JSON}" ]; then
          if [ -n "${MON}" ]; then
            RR=$(printf '%s' "$JSON" | MON="$MON" jq -r 'map(select(.name==env.MON)) | .[0].refreshRate // empty')
          else
            RR=$(printf '%s' "$JSON" | jq -r 'map(select(.focused==true)) | .[0].refreshRate // empty')
          fi
          if [ -n "${RR}" ] && [ "${RR}" != "null" ]; then
            RATE=$(awk -v r="$RR" 'BEGIN{ printf("%d", (r<1)?0:int(r+0.5)) }')
          fi
        fi
      fi
      RATEFLAG=""; [ -n "${RATE}" ] && RATEFLAG="-r ${RATE}"
      FLAGS="-f --adaptive-sync ${RATEFLAG} -W ${OUT_W} -H ${OUT_H}"
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
    runtimeInputs = [pkgs.util-linux pkgs.gamescope pkgs.gamemode pkgs.zenity pkgs.jq];
    text = ''
      set -euo pipefail
      CPUSET="${GAME_PIN_CPUSET:-14,15,30,31}"
      MON="${GAMESCOPE_MON:-}"
      OUT_W="${GAMESCOPE_OUT_W:-}"; OUT_H="${GAMESCOPE_OUT_H:-}"
      if [ -z "${OUT_W}" ] || [ -z "${OUT_H}" ]; then
        if command -v hyprctl >/dev/null 2>&1; then
          JSON=$(hyprctl monitors -j 2>/dev/null || true)
          if [ -n "${JSON}" ]; then
            if [ -z "${MON}" ]; then
              BEST=$(printf '%s' "$JSON" | jq -r 'sort_by([.refreshRate, (.width // 0) * (.height // 0)]) | reverse | .[0].name // empty')
              [ -n "${BEST}" ] && MON="${BEST}"
            fi
            if [ -n "${MON}" ]; then
              W=$(printf '%s' "$JSON" | MON="$MON" jq -r 'map(select(.name==env.MON)) | .[0].width // empty')
              H=$(printf '%s' "$JSON" | MON="$MON" jq -r 'map(select(.name==env.MON)) | .[0].height // empty')
            else
              W=$(printf '%s' "$JSON" | jq -r 'map(select(.focused==true)) | .[0].width // empty')
              H=$(printf '%s' "$JSON" | jq -r 'map(select(.focused==true)) | .[0].height // empty')
            fi
            if [ -n "${W}" ] && [ -n "${H}" ]; then
              OUT_W=${OUT_W:-$W}
              OUT_H=${OUT_H:-$H}
            fi
          fi
        fi
      fi
      OUT_W="${OUT_W:-3840}"; OUT_H="${OUT_H:-2160}"
      if [ -n "${MON}" ] && command -v hyprctl >/dev/null 2>&1; then
        hyprctl dispatch focusmonitor "${MON}" >/dev/null 2>&1 || true
      fi
      RATE="${GAMESCOPE_RATE:-}"
      if [ -z "${RATE}" ] && command -v hyprctl >/dev/null 2>&1; then
        JSON=${JSON:-""}
        if [ -z "${JSON}" ]; then JSON=$(hyprctl monitors -j 2>/dev/null || true); fi
        if [ -n "${JSON}" ]; then
          if [ -n "${MON}" ]; then
            RR=$(printf '%s' "$JSON" | MON="$MON" jq -r 'map(select(.name==env.MON)) | .[0].refreshRate // empty')
          else
            RR=$(printf '%s' "$JSON" | jq -r 'map(select(.focused==true)) | .[0].refreshRate // empty')
          fi
          if [ -n "${RR}" ] && [ "${RR}" != "null" ]; then
            RATE=$(awk -v r="$RR" 'BEGIN{ printf("%d", (r<1)?0:int(r+0.5)) }')
          fi
        fi
      fi
      RATEFLAG=""; [ -n "${RATE}" ] && RATEFLAG="-r ${RATE}"
      FLAGS="-f --adaptive-sync ${RATEFLAG} --hdr-enabled -W ${OUT_W} -H ${OUT_H}"
      if [ "$#" -eq 0 ]; then
        CMD=$(zenity --entry --title="Gamescope HDR" --text="Command to run:" || true)
        [ -z "${CMD:-}" ] && exit 0
        exec taskset -c "$CPUSET" gamemoderun gamescope $FLAGS -- bash -lc "$CMD"
      else
        exec taskset -c "$CPUSET" gamemoderun gamescope $FLAGS -- "$@"
      fi
    '';
  };

  gamescopeTargetFPS = pkgs.writeShellApplication {
    name = "gamescope-targetfps";
    runtimeInputs = [pkgs.util-linux pkgs.gamescope pkgs.gamemode pkgs.jq pkgs.gawk pkgs.zenity];
    text = ''
      set -euo pipefail
      CPUSET="${GAME_PIN_CPUSET:-14,15,30,31}"
      MON="${GAMESCOPE_MON:-}"
      # By default autoscale is OFF unless explicitly requested
      TARGET="${TARGET_FPS:-}"
      BASE="${NATIVE_BASE_FPS:-60}"
      AUTOSCALE="${GAMESCOPE_AUTOSCALE:-}"

      # Detect monitor and resolution (prefer selected, else best, else focused)
      OUT_W="${GAMESCOPE_OUT_W:-}"; OUT_H="${GAMESCOPE_OUT_H:-}"
      if [ -z "${OUT_W}" ] || [ -z "${OUT_H}" ]; then
        if command -v hyprctl >/dev/null 2>&1; then
          JSON=$(hyprctl monitors -j 2>/dev/null || true)
          if [ -n "${JSON}" ]; then
            if [ -z "${MON}" ]; then
              BEST=$(printf '%s' "$JSON" | jq -r 'sort_by([.refreshRate, (.width // 0) * (.height // 0)]) | reverse | .[0].name // empty')
              [ -n "${BEST}" ] && MON="${BEST}"
            fi
            if [ -n "${MON}" ]; then
              W=$(printf '%s' "$JSON" | MON="$MON" jq -r 'map(select(.name==env.MON)) | .[0].width // empty')
              H=$(printf '%s' "$JSON" | MON="$MON" jq -r 'map(select(.name==env.MON)) | .[0].height // empty')
            else
              W=$(printf '%s' "$JSON" | jq -r 'map(select(.focused==true)) | .[0].width // empty')
              H=$(printf '%s' "$JSON" | jq -r 'map(select(.focused==true)) | .[0].height // empty')
            fi
            if [ -n "${W}" ] && [ -n "${H}" ]; then
              OUT_W=${OUT_W:-$W}
              OUT_H=${OUT_H:-$H}
            fi
          fi
        fi
      fi
      OUT_W="${OUT_W:-3840}"; OUT_H="${OUT_H:-2160}"

      # Focus chosen monitor if available
      if [ -n "${MON}" ] && command -v hyprctl >/dev/null 2>&1; then
        hyprctl dispatch focusmonitor "${MON}" >/dev/null 2>&1 || true
      fi

      # Choose refresh rate (env override wins)
      RATE="${GAMESCOPE_RATE:-}"
      if [ -z "${RATE}" ] && command -v hyprctl >/dev/null 2>&1; then
        JSON=${JSON:-""}
        if [ -z "${JSON}" ]; then JSON=$(hyprctl monitors -j 2>/dev/null || true); fi
        if [ -n "${JSON}" ]; then
          if [ -n "${MON}" ]; then
            RR=$(printf '%s' "$JSON" | MON="$MON" jq -r 'map(select(.name==env.MON)) | .[0].refreshRate // empty')
          else
            RR=$(printf '%s' "$JSON" | jq -r 'map(select(.focused==true)) | .[0].refreshRate // empty')
          fi
          if [ -n "${RR}" ] && [ "${RR}" != "null" ]; then
            RATE=$(awk -v r="$RR" 'BEGIN{ printf("%d", (r<1)?0:int(r+0.5)) }')
          fi
        fi
      fi
      RATEFLAG=""; [ -n "${RATE}" ] && RATEFLAG="-r ${RATE}"

      # Heuristic autoscale (opt-in):
      # - enable when TARGET_FPS is set OR GAMESCOPE_AUTOSCALE=1
      # - formula: scale ≈ sqrt(BASE/TARGET) clamped to [0.5,1.0]
      if [ -n "${TARGET}" ] || [ "${AUTOSCALE}" = "1" ]; then
        if [ -z "${TARGET}" ]; then TARGET=120; fi
        SCALE=$(awk -v a="$BASE" -v t="$TARGET" 'BEGIN{ if(t<=0||a<=0){s=1.0}else{s=sqrt(a/t)}; if(s<0.5)s=0.5; if(s>1.0)s=1.0; printf("%.3f", s) }')
      else
        SCALE=1.0
      fi
      GAME_W=$(awk -v w="$OUT_W" -v s="$SCALE" 'BEGIN{ printf("%d", int(w*s+0.5)) }')
      GAME_H=$(awk -v h="$OUT_H" -v s="$SCALE" 'BEGIN{ printf("%d", int(h*s+0.5)) }')

      if [ "$#" -eq 0 ]; then
        CMD=$(zenity --entry --title="Gamescope Target FPS" --text="Command to run (scale ${SCALE}${TARGET:+, target ${TARGET} FPS}):" || true)
        [ -z "${CMD:-}" ] && exit 0
        exec taskset -c "$CPUSET" gamemoderun gamescope -f --adaptive-sync ${RATEFLAG} -w "$GAME_W" -h "$GAME_H" -W "$OUT_W" -H "$OUT_H" --fsr-sharpness 3 -- bash -lc "$CMD"
      else
        exec taskset -c "$CPUSET" gamemoderun gamescope -f --adaptive-sync ${RATEFLAG} -w "$GAME_W" -h "$GAME_H" -W "$OUT_W" -H "$OUT_H" --fsr-sharpness 3 -- "$@"
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
  options.profiles.games = {
    autoscaleDefault = lib.mkEnableOption "Enable autoscale heuristics by default for gamescope-targetfps.";
    targetFps = lib.mkOption {
      type = lib.types.int;
      default = 120;
      description = "Default target FPS used when autoscale is enabled globally or TARGET_FPS is unset.";
      example = 240;
    };
    nativeBaseFps = lib.mkOption {
      type = lib.types.int;
      default = 60;
      description = "Estimated FPS at native resolution used as baseline for autoscale heuristic.";
      example = 80;
    };
  };

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
    gamescopeTargetFPS
    gamescopePerfDesktop
    gamescopeQualityDesktop
    gamescopeHDRDesktop
  ];

  # Global defaults for target-fps wrapper (opt-in switch)
  environment.variables = lib.mkIf (cfg.autoscaleDefault or false) {
    GAMESCOPE_AUTOSCALE = "1";
    TARGET_FPS = builtins.toString (cfg.targetFps or 120);
    NATIVE_BASE_FPS = builtins.toString (cfg.nativeBaseFps or 60);
  };

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
