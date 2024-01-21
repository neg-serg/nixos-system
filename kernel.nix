{ config, lib, ... }:
let mitigations_settings = [
        "noibrs" # Disables the Indirect Branch Restricted Speculation (IBRS) feature, which is a hardware mitigation for Spectre variant 2
                 # (CVE-2017-5715). Disabling this feature can improve performance, but it can also make the system more vulnerable to Spectre variant 2 attacks.
        "noibpb" # Disables the Indirect Branch Predictor Barrier (IBPB) feature, which is a software mitigation for Spectre variant 2.
                 # Disabling this feature can improve performance, but it can also make the system more vulnerable to Spectre variant 2 attacks.
        "no_stf_barrier" # Disables the Indirect Branch Predictor Barrier (IBPB) feature, which is a software mitigation for Spectre variant 2.
                         # Disabling this feature can improve performance, but it can also make the system more vulnerable to Spectre variant 2 attacks.
        "mds=off" # Disables the Microarchitectural Data Sampling (MDS) mitigation, which is a hardware mitigation for MDS (CVE-2018-12126,
                  # CVE-2018-12127, CVE-2018-12130, CVE-2019-11091). Disabling this feature can improve performance, but it can also make the system more
                  # vulnerable to MDS attacks.
        # "tsx=on" # Enables Intel Transactional Synchronization Extensions (TSX), which can improve performance for certain workloads that
        #          # use transactional memory.
        # "tsx_async_abort=off" # Disables the TSX Asynchronous Abort (TAA) mitigation, which is a hardware mitigation for TAA
        #                       # (CVE-2019-11135). Disabling this feature can improve performance, but it can also make the system more vulnerable to TAA attacks.
        "mitigations=off" # Disables all security mitigations. This can significantly improve performance, but it can also make the system very vulnerable to security attacks.
        "l1tf=off" # Disables the L1 Terminal Fault (L1TF) mitigation, which is a hardware mitigation for L1TF (CVE-2018-3620 and
                   # CVE-2018-3646). Disabling this feature can improve performance, but it can also make the system more vulnerable to L1TF attacks.
        "nospec_store_bypass_disable" # Disables the Speculative Store Bypass Disable (SSBD) feature, which is a hardware mitigation for
                                      # Spectre variant 4 (CVE-2018-3639). Disabling this feature can improve performance, but it can also make the system more vulnerable to Spectre variant 4 attacks.
        "nospectre_v1" # Disables all mitigations for Spectre variant 1 (CVE-2017-5753). This can improve performance, but it can also make the system more vulnerable to Spectre variant 1 attacks.
        "nospectre_v2" # Disables all mitigations for Spectre variant 2, including IBRS and IBPB. This can significantly improve performance, but it can also make the system more vulnerable to Spectre variant 2 attacks.
        "nopti" # Disables the Kernel Page Table Isolation (KPTI) feature, which is a software mitigation for Meltdown (CVE-2017-5754).
                # Disabling this feature can improve performance, but it can also make the system more vulnerable to Meltdown attacks.
        ];
  extra_security = [
      "page_poison=1" # Overwrite free'd memory
      "page_alloc.shuffle=1" # Enable page allocator randomization
  ]; in {
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
        # blacklist nvidiafb
        "snd_hda_intel"
        "snd_hda_codec_hdmi"
        "snd_hda_codec"
        "snd_hda_core"
        # Obscure network protocols
        "ax25"
        "netrom"
        "rose"
        # Old or rare or insufficiently audited filesystems
        "adfs"
        "affs"
        "bfs"
        "befs"
        "cramfs"
        "efs"
        "erofs"
        "exofs"
        "freevxfs"
        "vivid"
        "gfs2"
        "ksmbd"
        "cramfs"
        "freevxfs"
        "jffs2"
        "hfs"
        "hfsplus"
        "squashfs"
        "udf"
        "hpfs"
        "jfs"
        "minix"
        "nilfs2"
        "omfs"
        "qnx4"
        "qnx6"
        "sysv"
        "ufs"
        # Disable watchdog for better performance
        # wiki.archlinux.org/title/improving_performance#Watchdogs
        "sp5100_tco"
    ];
    boot.kernelParams = [
        "rootflags=rw,relatime,lazytime,background_gc=on,discard,no_heap,user_xattr,inline_xattr,acl,inline_data,inline_dentry,flush_merge,extent_cache,mode=adaptive,active_logs=6,alloc_mode=default,fsync_mode=posix"

        "acpi_osi=!"
        "acpi_osi=Linux"
        "amd_iommu=on"
        "audit=0"
        "biosdevname=1"
        "cryptomgr.notests"
        "iommu=pt"
        "loglevel=0"
        "net.ifnames=0"
        "noreplace-smp"
        "no_timer_check"
        # https://wiki.archlinux.org/title/improving_performance#Watchdogs
        "nowatchdog" "kernel.nmi_watchdog=0"
        "nvidia-drm.modeset=1"
        "page_alloc.shuffle=1"
        "pcie_aspm=off"
        "quiet"
        "rcupdate.rcu_expedited=1"
        "rd.systemd.show_status=auto"
        "rd.udev.log_priority=3"
        "systemd.show_status=false"
        "threadirqs"
        "tsc=reliable"
        "vt.global_cursor_default=0"
        "preempt=full"
        "scsi_mod.use_blk_mq=1"
    ] ++ mitigations_settings;
    boot.extraModulePackages = [];
    boot.consoleLogLevel = 1;
}
