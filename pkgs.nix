{ pkgs, stable, inputs, ... }: {
    imports = [ ./python-lto.nix ];
    environment.systemPackages = with pkgs; [
        efibootmgr # rule efi boot
        efivar # manipulate efi vars
        os-prober # utility to detect other OSs on a set of drives

        bandwhich # display network utilization per process
        cacert # for curl certificate verification
        dnsutils # dns command-line tools (dig, nslookup)
        ethtool # control eth hardware and drivers
        fping # like ping -c1
        geoip # geoip lookup
        httpie # fancy curl
        httpstat # fancy curl -v
        iftop # display bandwidth
        inetutils # common network programs
        ipcalc # calculate ip addr stuff
        iputils # set of small useful utilities for Linux networking
        kexec-tools # tools related to the kexec Linux feature
        magic-wormhole # secure transfer between computers
        netcat-openbsd # openbsd netcat variant
        netdiscover # another network scan
        nettools # controlling the network subsystem in Linux
        nmap # port scanner
        procps # info about processes using /proc
        rclone # rsync for cloud storage
        socat # multipurpose relay
        sshfs # ssh mount
        tcpdump # best friend to show network stuff
        tcptraceroute # traceroute without icmp
        traceroute # basic traceroute
        w3m # cli browser

        curl # transfer curl
        wget2 # non-interactive downloader

        aircrack-ng # stuff for wifi security
        hcxdumptool # wpa scanner
        netsniff-ng # sniffer
        tshark # sniffer tui
        wireshark # sniffer gui

        ddrescue # data recovery tool
        foremost # files extact from structure

        gcc # gnu compiler collection
        gdb # gnu debugger
        hexyl # command-line hex editor
        hyperfine # command-line benchmarking tool
        imhex # gui hex editor
        ltrace # trace functions
        pkgconf # package compiler and linker metadata toolkit (wrapper script)
        radare2 # free disassembler
        stable.radare2-cutter # Free and Open Source Reverse Engineering Platform powered by rizin
        strace # trace system-calls

        git # my favorite dvcs
        git-extras # git extra stuff
        git-filter-repo # quickly rewrite git history
        git-lfs # git extension for large files

        openvpn # gnu/gpl vpn

        chrpath # adjust rpath for ELF
        debugedit # debug info rewrite
        delta # better diff tool
        dump_syms # parsing the debugging information
        elfutils # set of utilities to handle ELF objects
        stable.eza # more modern version of exa ls replacer
        fd # better find
        file # get filetype from content
        patchelf # for fixing up binaries in nix

        vis # minimal editor
        neovim # better vim

        alejandra # the uncompromising nix code formatter
        cached-nix-shell # nix-shell with instant startup
        cachix # for downloading pre-built binaries
        dconf2nix # convert dconf to nix config
        deadnix # scan for dead nix code
        manix # nixos documentation
        nh # some nice nix commands
        niv # pin different stuff
        nix-diff # show what causes derivation to be different
        nix-index # index for nix-locate
        nix-init # provides more easy way to create nix packages
        nix-output-monitor # fancy nix output (nom)
        nix-tree # Interactive scan current system / derivations for what-why-how depends
        nixos-shell # tool to create vm for current config
        npins # pin different stuff ( inspired by niv )
        nurl # cli to generate Nix fetcher calls from repository URLs
        nvd # compare versions: nvd diff /run/current-system result
        statix # static analyzer for nix

        bash-completion # generic bash completions
        nix-bash-completions # nix-related bash-completions
        nix-zsh-completions # nix-related zsh-completion

        abduco # cli session detach
        diffutils # classic diff utils
        inotify-tools # shell inotify bindings
        lsof # list open something
        parallel # parallel xargs
        progress # show progress over all coreutils
        psmisc # killall and friends
        pv # pipe viewer
        readline # readline library
        reptyr # move app to another pty, tmux as an example ( echo 0 > /proc/sys/kernel/yama/ptrace_scope )
        ripgrep # better grep
        rlwrap # readline wrapper for everything
        tig # git viewer
        tmux # better screen

        btop # even more fancy top
        dstat # example use: dstat -cdnpmgs --top-bio --top-cpu --top-mem
        htop # fancy top
        iotop # top for iops
        iperf iperf2 # IP bandwidth measurement
        linuxKernel.packages.linux_6_8.perf
        linuxKernel.packages.linux_6_8.turbostat # cpu monitor
        nethogs # network traffic per process
        powertop # watch for power events
        procdump # procdump for linux
        scx # for cachyos sched
        sysstat # sar, iostat, mpstat, pidstat and friends
        vmtouch # portable file system cache diagnostics and control

        terminus-nerdfont # font for tty

        keyd # systemwide key manager

        blktrace # another disk test
        dmraid # Old-style RAID configuration utility
        exfat exfatprogs # Exfat support
        fio # disk test
        gptfdisk # sgdisk
        ioping # io latency measuring tool
        mtools # utils for msdos disks
        multipath-tools # (kpartx) create loop devices for partitions in image
        nvme-cli # nvme manage tools
        ostree # git for os binaries
        parted # cli disk manager
        smartmontools # smartctl

        opensc # libraries and utilities to access smart cards
        p11-kit # loading and sharing PKCS#11 modules
        pcsctools # tools used to test a PC/SC driver, card or reader

        ddccontrol # ddc control
        ddcutil # rule monitor params
        edid-decode # edid decoder and tester
        read-edid # tool to read and parse edid from monitors
        xcalib # stuff for icc profiles

        dmidecode # extract system/memory/bios info
        lm_sensors # sensors
        pciutils # manipulate pci devices
        schedtool # CPU scheduling
        usbutils # lsusb

        sops # secret management
        age # pgp alternative

        xorg.xdpyinfo # display info

        (inputs.nix-gaming.packages.${pkgs.hostPlatform.system}.star-citizen.override {
            location="$HOME/games/star-citizen";
        })
    ];
}
