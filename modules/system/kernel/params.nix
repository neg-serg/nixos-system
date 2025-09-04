##
# Module: system/kernel/params
# Purpose: Compose boot.kernelParams and related kernel package/module settings.
# Key options: cfg = config.profiles.performance.*, config.profiles.security.enable
# Dependencies: Uses pkgs; respects kexec_enabled.
{
  lib,
  pkgs,
  config,
  kexec_enabled,
  ...
}: let
  # Toggles from profiles/performance.nix
  perfEnabled = config.profiles.performance.enable or false;

  mitigations_settings = ["mitigations=off"]; # full mitigations disable
  silence = [
    "quiet"
    "rd.systemd.show_status=auto"
    "rd.udev.log_priority=3"
    "splash"
    "systemd.show_status=false"
    "vt.global_cursor_default=0"
  ];
  intel_hda_modules = [
    "snd_hda_codec"
    "snd_hda_codec_hdmi"
    "snd_hda_core"
    "snd_hda_intel"
  ];
  extra_security = ["page_alloc.shuffle=1"];
  idle_nomwait = ["idle=nomwait"]; # latency over power
  usb_noautosuspend = ["usbcore.autosuspend=-1"]; # avoid hiccups
  no_watchdog = [
    "nowatchdog"
    "kernel.nmi_watchdog=0"
  ];
  obscure_network_protocols = ["ax25" "netrom" "rose"];
  old_rare_insufficiently_audited_fs = [
    "adfs"
    "affs"
    "befs"
    "bfs"
    "cramfs"
    "efs"
    "erofs"
    "exofs"
    "freevxfs"
    "gfs2"
    "hfs"
    "hfsplus"
    "hpfs"
    "jffs2"
    "jfs"
    "ksmbd"
    "minix"
    "nilfs2"
    "omfs"
    "qnx4"
    "qnx6"
    "squashfs"
    "sysv"
    "ufs"
    "vivid"
  ];

  base_params = [
    # Keep classic interface names for consistency
    "net.ifnames=0"
    # Kernel and early userspace verbosity
    "loglevel=7"
    # Show systemd unit status during boot (stage-1 and stage-2)
    "rd.systemd.show_status=true"
    "systemd.show_status=true"
    # Make udev a bit more chatty (initrd + real root)
    "rd.udev.log_priority=info"
    "udev.log_priority=info"
  ];

  perf_params =
    lib.optionals config.profiles.performance.disableAudit ["audit=0"]
    ++ lib.optionals config.profiles.performance.skipCryptoSelftests ["cryptomgr.notests"]
    ++ lib.optionals config.profiles.performance.noreplaceSmp ["noreplace-smp"]
    ++ lib.optionals config.profiles.performance.pciePerformance ["pcie_aspm=performance"]
    ++ lib.optionals config.profiles.performance.lowLatencyScheduling ["preempt=full" "threadirqs"]
    ++ lib.optionals config.profiles.performance.fastRCU ["rcupdate.rcu_expedited=1"]
    ++ lib.optionals config.profiles.performance.trustTSC ["tsc=reliable"]
    ++ lib.optionals config.profiles.performance.disableSplitLockDetect ["split_lock_detect=off"]
    ++ lib.optionals config.profiles.performance.disableMitigations mitigations_settings
    ++ lib.optionals config.profiles.performance.quietBoot silence
    ++ lib.optionals config.profiles.performance.disableWatchdogs no_watchdog
    ++ lib.optionals config.profiles.performance.idleNoMwait idle_nomwait
    ++ lib.optionals config.profiles.performance.disableUsbAutosuspend usb_noautosuspend
    ++ [
      "amd_pstate=active"
      "nvme_core.default_ps_max_latency_us=0"
    ]
    ++ lib.optionals (config.profiles.performance.zswap.enable or false) [
      "zswap.enabled=1"
      "zswap.compressor=${config.profiles.performance.zswap.compressor}"
      "zswap.max_pool_percent=${builtins.toString config.profiles.performance.zswap.maxPoolPercent}"
      "zswap.zpool=${config.profiles.performance.zswap.zpool}"
    ];
in {
  boot = {
    kernelModules = ["kvm-amd" "tcp_bbr" "amdgpu" "ntsync"];
    blacklistedKernelModules =
      ["sp5100_tco"]
      ++ obscure_network_protocols
      ++ intel_hda_modules
      ++ old_rare_insufficiently_audited_fs;

    kernelParams =
      base_params
      ++ lib.optionals perfEnabled perf_params
      ++ extra_security
      ++ lib.optionals (config.profiles.security.enable or false) ["page_poison=1"];

    extraModulePackages = [pkgs.linuxPackages_cachyos.amneziawg];
    # Increase kernel console verbosity on TTY
    consoleLogLevel = 7;
    kernelPackages = pkgs.linuxPackages_cachyos.cachyOverride {mArch = "GENERIC_V4";};
  };

  security.protectKernelImage = !kexec_enabled;
}
