{
  lib,
  pkgs,
  config,
  kexec_enabled,
  ...
}: let
  inherit (lib.kernel) yes no freeform;
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.modules) mkForce;
  # Toggle to include aggressive performance parameters; see profiles/performance.nix
  perfEnabled = config.profiles.performance.enable or false;
  # Disables all security mitigations. This can significantly improve performance, but it can also make the system very vulnerable to security attacks.
  mitigations_settings = [
    "mitigations=off"
  ];
  silence = [
    "quiet" # Reduce kernel log verbosity during boot
    "rd.systemd.show_status=auto" # In initramfs: show status only on failures
    "rd.udev.log_priority=3" # In initramfs: udev log level (3=warning)
    "splash" # Allow splash screen instead of text output
    "systemd.show_status=false" # Hide systemd unit status messages
    "vt.global_cursor_default=0" # Hide blinking cursor on virtual console
  ];
  intel_hda_modules = [
    "snd_hda_codec"
    "snd_hda_codec_hdmi"
    "snd_hda_core"
    "snd_hda_intel"
  ];
  extra_security = [
    "page_poison=1" # Overwrite/poison freed memory (helps catch UAF bugs)
    "page_alloc.shuffle=1" # Randomize page allocator to reduce predictability
  ];
  idle_nomwait = [
    "idle=nomwait" # Avoid MWAIT C-states (favor latency over power)
  ];
  usb_noautosuspend = [
    "usbcore.autosuspend=-1" # Disable USB autosuspend (prevents input/audio hiccups)
  ];
  # iommu_on = [ "amd_iommu=on" "iommu=pt" ];
  no_watchdog = [
    "nowatchdog" # Disable soft/hard lockup watchdogs
    "kernel.nmi_watchdog=0" # Disable NMI watchdog (lower overhead)
  ]; # https://wiki.archlinux.org/title/improving_performance#Watchdogs
  # -- Blacklist
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
  # Baseline params applied to all builds
  base_params = [
    "net.ifnames=0" # Keep traditional predictable names disabled (use eth0/wlan0)
  ];
  # Extra params applied only when profiles.performance.enable = true
  perf_params =
    lib.optionals config.profiles.performance.disableAudit [
      "audit=0"
    ]
    ++ lib.optionals config.profiles.performance.skipCryptoSelftests [
      "cryptomgr.notests"
    ]
    ++ lib.optionals config.profiles.performance.noreplaceSmp [
      "noreplace-smp"
    ]
    ++ lib.optionals config.profiles.performance.pciePerformance [
      "pcie_aspm=performance"
    ]
    ++ lib.optionals config.profiles.performance.lowLatencyScheduling [
      "preempt=full"
      "threadirqs"
    ]
    ++ lib.optionals config.profiles.performance.fastRCU [
      "rcupdate.rcu_expedited=1"
    ]
    ++ lib.optionals config.profiles.performance.trustTSC [
      "tsc=reliable"
    ]
    ++ lib.optionals config.profiles.performance.disableSplitLockDetect [
      "split_lock_detect=off"
    ]
    ++ lib.optionals config.profiles.performance.disableMitigations mitigations_settings
    ++ lib.optionals config.profiles.performance.quietBoot silence
    ++ lib.optionals config.profiles.performance.disableWatchdogs no_watchdog
    ++ lib.optionals config.profiles.performance.idleNoMwait idle_nomwait
    ++ lib.optionals config.profiles.performance.disableUsbAutosuspend usb_noautosuspend
    ++ [
      # Prefer modern AMD CPU frequency driver on Zen 3 (5950X)
      "amd_pstate=active"
    ]
    # zswap tuning (behind profiles.performance.zswap.enable)
    ++ lib.optionals (config.profiles.performance.zswap.enable or false) [
      "zswap.enabled=1"
      "zswap.compressor=${config.profiles.performance.zswap.compressor}"
      "zswap.max_pool_percent=${builtins.toString config.profiles.performance.zswap.maxPoolPercent}"
      "zswap.zpool=${config.profiles.performance.zswap.zpool}"
    ];
in {
  # thx to https://github.com/hlissner/dotfiles
  boot = {
    kernel.sysctl = {
      # The Magic SysRq key is a key combo that allows users connected to the
      # system console of a Linux kernel to perform some low-level commands.
      # Disable it, since we don't need it, and is a potential security concern.
      "kernel.sysrq" = 0;
      ## TCP hardening
      # Prevent bogus ICMP errors from filling up logs.
      "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
      # Reverse path filtering causes the kernel to do source validation of
      # packets received from all interfaces. This can mitigate IP spoofing.
      "net.ipv4.conf.default.rp_filter" = 1;
      "net.ipv4.conf.all.rp_filter" = 1;
      # Do not accept IP source route packets (we're not a router)
      "net.ipv4.conf.all.accept_source_route" = 0;
      "net.ipv6.conf.all.accept_source_route" = 0;
      # Don't send ICMP redirects (again, we're on a router)
      "net.ipv4.conf.all.send_redirects" = 0;
      "net.ipv4.conf.default.send_redirects" = 0;
      # Refuse ICMP redirects (MITM mitigations)
      "net.ipv4.conf.all.accept_redirects" = 0;
      "net.ipv4.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.all.secure_redirects" = 0;
      "net.ipv4.conf.default.secure_redirects" = 0;
      "net.ipv6.conf.all.accept_redirects" = 0;
      "net.ipv6.conf.default.accept_redirects" = 0;
      "net.ipv4.tcp_syncookies" = 1; # Protects against SYN flood attacks
      "net.ipv4.tcp_rfc1337" = 1; # Incomplete protection again TIME-WAIT assassination
      ## TCP optimization
      # TCP Fast Open is a TCP extension that reduces network latency by packing
      # data in the sender’s initial TCP SYN. Setting 3 = enable TCP Fast Open for
      # both incoming and outgoing connections:
      "net.ipv4.tcp_fastopen" = 3;
      # Bufferbloat mitigations + slight improvement in throughput & latency
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.core.default_qdisc" = "fq";
    };
    kernelModules = ["kvm-amd" "tcp_bbr" "amdgpu" "ntsync"];
    blacklistedKernelModules =
      [
        "sp5100_tco" # Disable watchdog for better performance wiki.archlinux.org/title/improving_performance#Watchdogs
      ]
      ++ obscure_network_protocols
      ++ intel_hda_modules
      ++ old_rare_insufficiently_audited_fs;
    kernelParams =
      base_params
      ++ lib.optionals perfEnabled perf_params
      ++ extra_security;
    kernelPatches = [
      {
        name = "amd-platform-patches"; # recompile with AMD platform specific optimizations
        patch = null; # no patch is needed, just apply the options
        structuredExtraConfig = mapAttrs (_: mkForce) {
          X86_AMD_PSTATE = yes;
          X86_EXTENDED_PLATFORM = no; # disable support for other x86 platforms
          X86_MCE_INTEL = no; # disable support for intel mce
          LRU_GEN = yes; # multigen LRU
          LRU_GEN_ENABLED = yes;
          CPU_FREQ_STAT = yes; # collect CPU frequency statistics

          HZ = freeform "1000";
          HZ_250 = lib.mkForce no;
          HZ_1000 = lib.mkForce yes;

          PREEMPT = yes;
          PREEMPT_BUILD = yes;
          PREEMPT_COUNT = yes;
          PREEMPT_VOLUNTARY = no;
          PREEMPTION = yes;

          TREE_RCU = yes;
          PREEMPT_RCU = yes;
          RCU_EXPERT = yes;
          TREE_SRCU = yes;
          TASKS_RCU_GENERIC = yes;
          TASKS_RCU = yes;
          TASKS_RUDE_RCU = yes;
          TASKS_TRACE_RCU = yes;
          RCU_STALL_COMMON = yes;
          RCU_NEED_SEGCBLIST = yes;
          RCU_FANOUT = freeform "64";
          RCU_FANOUT_LEAF = freeform "16";
          RCU_BOOST = yes;
          RCU_BOOST_DELAY = freeform "500";
          RCU_NOCB_CPU = yes;
          RCU_LAZY = yes;

        };
      }
    ];
    extraModulePackages = [pkgs.linuxPackages_cachyos.amneziawg];
    consoleLogLevel = 3;
    kernelPackages = pkgs.linuxPackages_cachyos.cachyOverride {mArch = "GENERIC_V4";};
  };
  security.protectKernelImage = !kexec_enabled;
}
