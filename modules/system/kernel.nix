{
  lib,
  pkgs,
  kexec_enabled,
  ...
}: let
  inherit (lib.kernel) yes no freeform;
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.modules) mkForce;
  # Disables all security mitigations. This can significantly improve performance, but it can also make the system very vulnerable to security attacks.
  mitigations_settings = [
    "mitigations=off"
  ];
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
  extra_security = [
    "page_poison=0" # Overwrite free'd memory
    "page_alloc.shuffle=1" # Enable page allocator randomization
  ];
  idle = [
    "idle=nomwait" # nomwait: Disable mwait for CPU C-states
    "usbcore.autosuspend=-1" # disable usb autosuspend
  ];
  # iommu_on = [ "amd_iommu=on" "iommu=pt" ];
  acpi_settings = ["acpi_osi=!" "acpi_osi=Linux"];
  no_watchdog = ["nowatchdog" "kernel.nmi_watchdog=0"]; # https://wiki.archlinux.org/title/improving_performance#Watchdogs
  video_settings = ["video=3440x1440@175"];
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
    "udf"
    "ufs"
    "vivid"
  ];
in {
  # thx to https://github.com/hlissner/dotfiles
  boot.kernel.sysctl = {
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
  boot.kernelModules = ["kvm-amd" "tcp_bbr" "amdgpu"];
  boot.blacklistedKernelModules =
    [
      "sp5100_tco" # Disable watchdog for better performance wiki.archlinux.org/title/improving_performance#Watchdogs
    ]
    ++ obscure_network_protocols
    ++ intel_hda_modules
    ++ old_rare_insufficiently_audited_fs;
  boot.kernelParams =
    [
      "audit=0"
      "biosdevname=1"
      "cryptomgr.notests"
      "loglevel=3"
      "net.ifnames=0"
      "noreplace-smp"
      "page_alloc.shuffle=1"
      "pcie_aspm=performance"
      "preempt=full"
      "rcupdate.rcu_expedited=1"
      "scsi_mod.use_blk_mq=1"
      "threadirqs"
      "tsc=reliable"
      "split_lock_detect=off"
    ]
    ++ mitigations_settings
    ++ silence
    ++ no_watchdog
    ++ extra_security
    ++ acpi_settings
    ++ video_settings
    ++ idle;
  boot.kernelPatches = [
    {
      name = "amd-platform-patches"; # recompile with AMD platform specific optimizations
      patch = null; # no patch is needed, just apply the options
      extraStructuredConfig = mapAttrs (_: mkForce) {
        X86_AMD_PSTATE = yes;
        X86_EXTENDED_PLATFORM = no; # disable support for other x86 platforms
        X86_MCE_INTEL = no; # disable support for intel mce
        LRU_GEN = yes; # multigen LRU
        LRU_GEN_ENABLED = yes;
        CPU_FREQ_STAT = yes; # collect CPU frequency statistics

        HZ = freeform "1000";
        HZ_1000 = yes;

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
  boot.extraModulePackages = [pkgs.linuxKernel.packages.linux_6_14.amneziawg];
  boot.consoleLogLevel = 1;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  security.protectKernelImage =
    if kexec_enabled == false
    then true
    else false;
}
