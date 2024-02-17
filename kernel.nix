let
  mitigations_settings = [
        # Disables all security mitigations. This can significantly improve performance, but it can also make the system very vulnerable to security attacks.
        "mitigations=off"
  ];
  extra_security = [
      "page_poison=1" # Overwrite free'd memory
      "page_alloc.shuffle=1" # Enable page allocator randomization
  ];
  f2fs_root_settings = [ "rootflags=rw,relatime,lazytime,background_gc=on,discard,no_heap,user_xattr,inline_xattr,acl,inline_data,inline_dentry,flush_merge,extent_cache,mode=adaptive,active_logs=6,alloc_mode=default,fsync_mode=posix" ];
  silence = [
      "quiet"
      "splash"
      "rd.systemd.show_status=auto"
      "rd.udev.log_priority=3"
      "systemd.show_status=false"
      "vt.global_cursor_default=0"
  ];
  acpi_settings = [ "acpi_osi=!" "acpi_osi=Linux" ];
  # https://wiki.archlinux.org/title/improving_performance#Watchdogs
  no_watchdog = [ "nowatchdog" "kernel.nmi_watchdog=0" ];
  iommu_on = [ "amd_iommu=on" "iommu=pt" ];
  video_settings = [ "nvidia_drm.modeset=1" "video=3440x1440@175" "modeset=1" "fbdev=1" ];

  # -- Blacklist
  obscure_network_protocols = [
      "ax25"
      "netrom"
      "rose"
  ];
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
        # Protects against SYN flood attacks
        "net.ipv4.tcp_syncookies" = 1;
        # Incomplete protection again TIME-WAIT assassination
        "net.ipv4.tcp_rfc1337" = 1;

        ## TCP optimization
        # TCP Fast Open is a TCP extension that reduces network latency by packing
        # data in the sender’s initial TCP SYN. Setting 3 = enable TCP Fast Open for
        # both incoming and outgoing connections:
        "net.ipv4.tcp_fastopen" = 3;
        # Bufferbloat mitigations + slight improvement in throughput & latency
        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.core.default_qdisc" = "cake";

        # NixOS configuration for Star Citizen requirements
        "vm.max_map_count" = 16777216;
        "fs.file-max" = 524288;
    };
    boot.kernelModules = ["kvm-amd" "tcp_bbr"];
    boot.blacklistedKernelModules=[
        "nouveau"
        "snd_hda_codec"
        "snd_hda_codec_hdmi"
        "snd_hda_core"
        "snd_hda_intel"
        # Disable watchdog for better performance wiki.archlinux.org/title/improving_performance#Watchdogs
        "sp5100_tco"
    ] ++ obscure_network_protocols ++ old_rare_insufficiently_audited_fs;
    boot.kernelParams = f2fs_root_settings ++ [
        "rootflags=rw,relatime,lazytime,background_gc=on,discard,no_heap,user_xattr,inline_xattr,acl,inline_data,inline_dentry,flush_merge,extent_cache,mode=adaptive,active_logs=6,alloc_mode=default,fsync_mode=posix"

        "audit=0"
        "biosdevname=1"
        "cryptomgr.notests"
        "loglevel=0"
        "net.ifnames=0"
        "noreplace-smp"
        "no_timer_check"
        "page_alloc.shuffle=1"
        "pcie_aspm=performance"
        "preempt=full"
        "rcupdate.rcu_expedited=1"
        "scsi_mod.use_blk_mq=1"
        "threadirqs"
        "tsc=reliable"

    ] ++ mitigations_settings ++ silence ++ no_watchdog ++ video_settings;
    boot.extraModulePackages = [];
    boot.consoleLogLevel = 1;
}
