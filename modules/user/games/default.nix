{pkgs, lib, config, ...}: let
  cfg = config.profiles.games or {};
  # Helper to strip common leading indentation from a multi-line string
  dedentPy = s: let
    lines = lib.splitString "\n" s;
    nonEmpty = lib.filter (l: l != "") lines;
    leading = l: let m = builtins.match "^( +)" l; in if m == null then 0 else builtins.stringLength (builtins.elemAt m 0);
    minIndent = if nonEmpty == [] then 0 else lib.foldl' (a: b: if b < a then b else a) 9999 (map leading nonEmpty);
    spaces = lib.concatStrings (builtins.genList (_: " ") minIndent);
    stripN = l: if lib.hasPrefix spaces l then lib.removePrefix spaces l else l;
  in lib.concatStringsSep "\n" (map stripN lines);
  # Python wrappers to avoid shell/Nix escaping pitfalls
  gamescopePinned = pkgs.writers.writePython3Bin "gamescope-pinned" {}
    (dedentPy ''
    import os
    import shlex
    import subprocess
    import sys

    TASKSET = "taskset"
    GAMEMODERUN = "gamemoderun"
    GAMESCOPE = "gamescope"

    cpuset = os.environ.get("GAME_PIN_CPUSET", "14,15,30,31")
    flags = os.environ.get("GAMESCOPE_FLAGS", "-f --adaptive-sync")

    cmd = (
        [TASKSET, "-c", cpuset, GAMEMODERUN, GAMESCOPE]
        + shlex.split(flags)
        + ["--"]
        + sys.argv[1:]
    )
    raise SystemExit(subprocess.call(cmd))
    '');

  gamePinned = pkgs.writers.writePython3Bin "game-pinned" {}
    (dedentPy ''
    import os
    import subprocess
    import sys

    TASKSET = "taskset"
    GAMEMODERUN = "gamemoderun"

    cpuset = os.environ.get("GAME_PIN_CPUSET", "14,15,30,31")
    cmd = [TASKSET, "-c", cpuset, GAMEMODERUN] + sys.argv[1:]
    raise SystemExit(subprocess.call(cmd))
    '');

  # (no-op placeholder removed)

  gamescopePerf = pkgs.writers.writePython3Bin "gamescope-perf" {}
    (dedentPy ''
    import json
    import os
    import shlex
    import subprocess
    import sys

    H = {
        "HYPRCTL": "hyprctl",
        "ZENITY": "zenity",
        "TASKSET": "taskset",
        "GAMEMODERUN": "gamemoderun",
        "GAMESCOPE": "gamescope",
    }


    def get_monitors():
        try:
            out = subprocess.check_output(
                [H["HYPRCTL"], "monitors", "-j"], text=True
            )
            return json.loads(out)
        except Exception:
            return []


    def pick_monitor(mon_name, mons):
        if mons:
            if mon_name:
                for m in mons:
                    if m.get("name") == mon_name:
                        return m
            focused = [m for m in mons if m.get("focused")]
            if focused:
                return focused[0]
            # best by refresh then resolution
            return sorted(
                mons,
                key=lambda m: (
                    m.get("refreshRate", 0),
                    (m.get("width", 0) * m.get("height", 0)),
                ),
                reverse=True,
            )[0]
        return None


    cpuset = os.environ.get("GAME_PIN_CPUSET", "14,15,30,31")
    mon_env = os.environ.get("GAMESCOPE_MON")
    out_w = os.environ.get("GAMESCOPE_OUT_W")
    out_h = os.environ.get("GAMESCOPE_OUT_H")
    mons = get_monitors()
    mon = pick_monitor(mon_env, mons)
    if not out_w or not out_h:
        if mon:
            out_w = out_w or str(mon.get("width", 3840))
            out_h = out_h or str(mon.get("height", 2160))
        else:
            out_w = out_w or "3840"
            out_h = out_h or "2160"

    # focus chosen monitor
    if mon_env:
        try:
            subprocess.run(
                [H["HYPRCTL"], "dispatch", "focusmonitor", mon_env],
                check=False,
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
            )
        except Exception:
            pass

    rate = os.environ.get("GAMESCOPE_RATE")
    if not rate and mon:
        rr = mon.get("refreshRate")
        if rr:
            rate = str(int(round(rr)))

    game_w = os.environ.get("GAMESCOPE_GAME_W")
    game_h = os.environ.get("GAMESCOPE_GAME_H")
    if not game_w or not game_h:
        game_w = game_w or str(int(int(out_w) * 2 / 3))
        game_h = game_h or str(int(int(out_h) * 2 / 3))

    flags = ["-f", "--adaptive-sync"]
    if rate:
        flags += ["-r", rate]
    flags += [
        "-w",
        game_w,
        "-h",
        game_h,
        "-W",
        out_w,
        "-H",
        out_h,
        "--fsr-sharpness",
        "3",
    ]

    if len(sys.argv) == 1:
        try:
            cmd_str = subprocess.check_output(
                [
                    H["ZENITY"],
                    "--entry",
                    "--title=Gamescope Performance",
                    "--text=Command to run:",
                ],
                text=True,
            ).strip()
        except Exception:
            cmd_str = ""
        if not cmd_str:
            sys.exit(0)
        args = shlex.split(cmd_str)
    else:
        args = sys.argv[1:]

    cmd = (
        [H["TASKSET"], "-c", cpuset, H["GAMEMODERUN"], H["GAMESCOPE"]]
        + flags
        + ["--"]
        + args
    )
    raise SystemExit(subprocess.call(cmd))
    '');

  gamescopeQuality = pkgs.writers.writePython3Bin "gamescope-quality" {}
    (dedentPy ''
    import json
    import os
    import shlex
    import subprocess
    import sys

    H = {
        "HYPRCTL": "hyprctl",
        "ZENITY": "zenity",
        "TASKSET": "taskset",
        "GAMEMODERUN": "gamemoderun",
        "GAMESCOPE": "gamescope",
    }


    def get_monitors():
        try:
            out = subprocess.check_output(
                [H["HYPRCTL"], "monitors", "-j"], text=True
            )
            return json.loads(out)
        except Exception:
            return []


    def pick_monitor(mon_name, mons):
        if mons:
            if mon_name:
                for m in mons:
                    if m.get("name") == mon_name:
                        return m
            focused = [m for m in mons if m.get("focused")]
            if focused:
                return focused[0]
            return sorted(
                mons,
                key=lambda m: (
                    m.get("refreshRate", 0),
                    (m.get("width", 0) * m.get("height", 0)),
                ),
                reverse=True,
            )[0]
        return None


    cpuset = os.environ.get("GAME_PIN_CPUSET", "14,15,30,31")
    mon_env = os.environ.get("GAMESCOPE_MON")
    out_w = os.environ.get("GAMESCOPE_OUT_W") or ""
    out_h = os.environ.get("GAMESCOPE_OUT_H") or ""
    mons = get_monitors()
    mon = pick_monitor(mon_env, mons)
    if not out_w or not out_h:
        if mon:
            out_w = out_w or str(mon.get("width", 3840))
            out_h = out_h or str(mon.get("height", 2160))
        else:
            out_w = out_w or "3840"
            out_h = out_h or "2160"

    if mon_env:
        try:
            subprocess.run(
                [H["HYPRCTL"], "dispatch", "focusmonitor", mon_env],
                check=False,
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
            )
        except Exception:
            pass

    rate = os.environ.get("GAMESCOPE_RATE")
    if not rate and mon:
        rr = mon.get("refreshRate")
        if rr:
            rate = str(int(round(rr)))

    flags = ["-f", "--adaptive-sync"]
    if rate:
        flags += ["-r", rate]
    flags += [
        "-W",
        out_w,
        "-H",
        out_h,
    ]

    if len(sys.argv) == 1:
        try:
            cmd_str = subprocess.check_output(
                [
                    H["ZENITY"],
                    "--entry",
                    "--title=Gamescope Quality",
                    "--text=Command to run:",
                ],
                text=True,
            ).strip()
        except Exception:
            cmd_str = ""
        if not cmd_str:
            sys.exit(0)
        args = shlex.split(cmd_str)
    else:
        args = sys.argv[1:]

    cmd = (
        [H["TASKSET"], "-c", cpuset, H["GAMEMODERUN"], H["GAMESCOPE"]]
        + flags
        + ["--"]
        + args
    )
    raise SystemExit(subprocess.call(cmd))
    '');

  gamescopeHDR = pkgs.writers.writePython3Bin "gamescope-hdr" {}
    (dedentPy ''
    import json
    import os
    import shlex
    import subprocess
    import sys

    H = {
        "HYPRCTL": "hyprctl",
        "ZENITY": "zenity",
        "TASKSET": "taskset",
        "GAMEMODERUN": "gamemoderun",
        "GAMESCOPE": "gamescope",
    }


    def get_monitors():
        try:
            out = subprocess.check_output(
                [H["HYPRCTL"], "monitors", "-j"], text=True
            )
            return json.loads(out)
        except Exception:
            return []


    def pick_monitor(mon_name, mons):
        if mons:
            if mon_name:
                for m in mons:
                    if m.get("name") == mon_name:
                        return m
            focused = [m for m in mons if m.get("focused")]
            if focused:
                return focused[0]
            return sorted(
                mons,
                key=lambda m: (
                    m.get("refreshRate", 0),
                    (m.get("width", 0) * m.get("height", 0)),
                ),
                reverse=True,
            )[0]
        return None


    cpuset = os.environ.get("GAME_PIN_CPUSET", "14,15,30,31")
    mon_env = os.environ.get("GAMESCOPE_MON")
    out_w = os.environ.get("GAMESCOPE_OUT_W") or ""
    out_h = os.environ.get("GAMESCOPE_OUT_H") or ""
    mons = get_monitors()
    mon = pick_monitor(mon_env, mons)
    if not out_w or not out_h:
        if mon:
            out_w = out_w or str(mon.get("width", 3840))
            out_h = out_h or str(mon.get("height", 2160))
        else:
            out_w = out_w or "3840"
            out_h = out_h or "2160"

    if mon_env:
        try:
            subprocess.run(
                [H["HYPRCTL"], "dispatch", "focusmonitor", mon_env],
                check=False,
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
            )
        except Exception:
            pass

    rate = os.environ.get("GAMESCOPE_RATE")
    if not rate and mon:
        rr = mon.get("refreshRate")
        if rr:
            rate = str(int(round(rr)))

    flags = ["-f", "--adaptive-sync", "--hdr-enabled"]
    if rate:
        flags += ["-r", rate]
    flags += [
        "-W",
        out_w,
        "-H",
        out_h,
    ]

    if len(sys.argv) == 1:
        try:
            cmd_str = subprocess.check_output(
                [
                    H["ZENITY"],
                    "--entry",
                    "--title=Gamescope HDR",
                    "--text=Command to run:",
                ],
                text=True,
            ).strip()
        except Exception:
            cmd_str = ""
        if not cmd_str:
            sys.exit(0)
        args = shlex.split(cmd_str)
    else:
        args = sys.argv[1:]

    cmd = (
        [H["TASKSET"], "-c", cpuset, H["GAMEMODERUN"], H["GAMESCOPE"]]
        + flags
        + ["--"]
        + args
    )
    raise SystemExit(subprocess.call(cmd))
    '');

  gamescopeTargetFPS = pkgs.writers.writePython3Bin "gamescope-targetfps" {}
    (dedentPy ''
    import json
    import math
    import os
    import shlex
    import subprocess
    import sys

    H = {
        "HYPRCTL": "hyprctl",
        "ZENITY": "zenity",
        "TASKSET": "taskset",
        "GAMEMODERUN": "gamemoderun",
        "GAMESCOPE": "gamescope",
    }


    def get_monitors():
        try:
            out = subprocess.check_output(
                [H["HYPRCTL"], "monitors", "-j"], text=True
            )
            return json.loads(out)
        except Exception:
            return []


    def pick_monitor(mon_name, mons):
        if mons:
            if mon_name:
                for m in mons:
                    if m.get("name") == mon_name:
                        return m
            focused = [m for m in mons if m.get("focused")]
            if focused:
                return focused[0]
            return sorted(
                mons,
                key=lambda m: (
                    m.get("refreshRate", 0),
                    (m.get("width", 0) * m.get("height", 0)),
                ),
                reverse=True,
            )[0]
        return None


    cpuset = os.environ.get("GAME_PIN_CPUSET", "14,15,30,31")
    mon_env = os.environ.get("GAMESCOPE_MON")
    target = os.environ.get("TARGET_FPS")
    base = float(os.environ.get("NATIVE_BASE_FPS", "60"))
    autoscale = os.environ.get("GAMESCOPE_AUTOSCALE") == "1"

    out_w = os.environ.get("GAMESCOPE_OUT_W") or ""
    out_h = os.environ.get("GAMESCOPE_OUT_H") or ""
    mons = get_monitors()
    mon = pick_monitor(mon_env, mons)
    if not out_w or not out_h:
        if mon:
            out_w = out_w or str(mon.get("width", 3840))
            out_h = out_h or str(mon.get("height", 2160))
        else:
            out_w = out_w or "3840"
            out_h = out_h or "2160"

    if mon_env:
        try:
            subprocess.run(
                [H["HYPRCTL"], "dispatch", "focusmonitor", mon_env],
                check=False,
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
            )
        except Exception:
            pass

    rate = os.environ.get("GAMESCOPE_RATE")
    if not rate and mon:
        rr = mon.get("refreshRate")
        if rr:
            rate = str(int(round(rr)))

    # Heuristic autoscale
    scale = 1.0
    if target or autoscale:
        t = float(target or 120)
        if base > 0 and t > 0:
            scale = max(0.5, min(1.0, math.sqrt(base / t)))
    game_w = str(int(round(int(out_w) * scale)))
    game_h = str(int(round(int(out_h) * scale)))

    flags = ["-f", "--adaptive-sync"]
    if rate:
        flags += ["-r", rate]
    flags += [
        "-w",
        game_w,
        "-h",
        game_h,
        "-W",
        out_w,
        "-H",
        out_h,
        "--fsr-sharpness",
        "3",
    ]

    if len(sys.argv) == 1:
        prompt = f"Command to run (scale {scale:.3f}"
        if target:
            prompt += f", target {target} FPS"
        prompt += "):"
        try:
            cmd_str = subprocess.check_output(
                [
                    H["ZENITY"],
                    "--entry",
                    "--title=Gamescope Target FPS",
                    f"--text={prompt}",
                ],
                text=True,
            ).strip()
        except Exception:
            cmd_str = ""
        if not cmd_str:
            sys.exit(0)
        args = shlex.split(cmd_str)
    else:
        args = sys.argv[1:]

    cmd = (
        [H["TASKSET"], "-c", cpuset, H["GAMEMODERUN"], H["GAMESCOPE"]]
        + flags
        + ["--"]
        + args
    )
    raise SystemExit(subprocess.call(cmd))
    '');

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
      default = 240;
      description = "Default target FPS used when autoscale is enabled globally or TARGET_FPS is unset.";
      example = 240;
    };
    nativeBaseFps = lib.mkOption {
      type = lib.types.int;
      default = 240;
      description = "Estimated FPS at native resolution used as baseline for autoscale heuristic.";
      example = 240;
    };
  };

  config = {
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

      # MangoHud is installed via systemPackages; toggle via MANGOHUD=1
    };

    environment = {
      systemPackages = with pkgs; [
        protontricks
        mangohud
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
      variables = lib.mkIf (cfg.autoscaleDefault or false) {
        GAMESCOPE_AUTOSCALE = "1";
        TARGET_FPS = builtins.toString (cfg.targetFps or 120);
        NATIVE_BASE_FPS = builtins.toString (cfg.nativeBaseFps or 60);
      };

      # System-wide MangoHud defaults
      etc."xdg/MangoHud/MangoHud.conf".text = ''
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
    };

    security.wrappers.gamemode = {
      owner = "root";
      group = "root";
      source = "${pkgs.gamemode}/bin/gamemoderun";
      capabilities = "cap_sys_ptrace,cap_sys_nice+pie";
    };

    # Expose udev rules/devices used by various game controllers/VR etc
    hardware.steam-hardware.enable = true;
  };
}
