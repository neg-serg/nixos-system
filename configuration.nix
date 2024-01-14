# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, lib, pkgs, modulesPath, packageOverrides, inputs, ... }:
{
    imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
        ./boot.nix
        ./kernel.nix
        ./filesystems.nix
        ./locale.nix
        ./networking.nix
        ./nvidia.nix
        ./udev-rules.nix
        ./python-lto.nix
        ./session.nix
        ./keyd.nix
        ./kmscon.nix
    ];
    nix = {
        extraOptions = ''experimental-features = nix-command flakes repl-flake'';
        settings = {
            trusted-users = ["root" "neg"];
            substituters = [
                "https://ezkea.cachix.org"
                "https://nix-gaming.cachix.org"
            ];
            trusted-public-keys = [
                "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
                "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
            ];
        };
        gc = {automatic = true; dates = "weekly"; options = "--delete-older-than 21d";};
    };
    nixpkgs.config.allowUnfree = true;

    systemd = {
        extraConfig = '' DefaultTimeoutStopSec=10s '';
        packages = [pkgs.packagekit];

        services."autovt@tty1".enable = false;
        services."getty@tty1".enable = false;
    };

    security = {
        pam = { loginLimits = [{domain = "@users"; item = "rtprio"; type = "-"; value = 1;}]; };
        polkit.enable = true;
        rtkit.enable = true; # rtkit recommended for pipewire
        sudo.execWheelOnly = true;
        sudo.wheelNeedsPassword = false;
    };

    environment.shells = with pkgs; [zsh];
    # This is using a rec (recursive) expression to set and access XDG_BIN_HOME within the expression
    # For more on rec expressions see https://nix.dev/tutorials/first-steps/nix-language#recursive-attribute-set-rec
    environment.sessionVariables = rec {
        XDG_BIN_HOME = "$HOME/.local/bin";
        XDG_CACHE_HOME = "$HOME/.cache";
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_DATA_HOME = "$HOME/.local/share";
        XDG_STATE_HOME = "$HOME/.local/state";

        XDG_DESKTOP_DIR="$HOME/1st_level/desktop";
        XDG_DOCUMENTS_DIR="$HOME/doc";
        XDG_DOWNLOAD_DIR="$HOME/dw";
        XDG_MUSIC_DIR="$HOME/music";
        XDG_PICTURES_DIR="$HOME/pic";
        XDG_PUBLICSHARE_DIR="$HOME/1st_level/public";
        XDG_TEMPLATES_DIR="$HOME/1st_level/templates";
        XDG_VIDEOS_DIR="$HOME/vid";

        PATH = ["${XDG_BIN_HOME}"];
        ZDOTDIR = "$HOME/.config/zsh";
    };

    # systemwide xdg-ninja
    environment.variables = {
        __GL_SHADER_DISK_CACHE_PATH = "$XDG_CACHE_HOME/nv";
        ASPELL_CONF = ''
            per-conf $XDG_CONFIG_HOME/aspell/aspell.conf;
        personal $XDG_CONFIG_HOME/aspell/en_US.pws;
        repl $XDG_CONFIG_HOME/aspell/en.prepl;
        '';
        CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
        HISTFILE = "$XDG_DATA_HOME/bash/history";
        INPUTRC = "$XDG_CONFIG_HOME/readline/inputrc";
        LESSHISTFILE = "$XDG_CACHE_HOME/lesshst";
        WGETRC = "$XDG_CONFIG_HOME/wgetrc";
    };

    hardware.i2c.enable = true;
    hardware.pulseaudio.enable = false;
    hardware.bluetooth = {
        enable = true;
        powerOnBoot = false;
        settings = {General.Enable = "Source,Sink,Media,Socket";};
    };
    powerManagement.cpuFreqGovernor = "performance";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    hardware.openrazer.enable = true; # Enable the OpenRazer driver for my Razer stuff
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
        lowLatency = { enable = true; quantum = 64; rate = 48000; };
    };

    users = {
        users.neg = {
            packages = with pkgs; [pam_u2f python3-lto];
            isNormalUser = true;
            description = "Neg";
            extraGroups = [
                "adbusers"
                "audio"
                "i2c"
                "input"
                "neg"
                "networkmanager"
                "openrazer"
                "systemd-journal"
                "video"
                "wheel"
            ];
        };
        defaultUserShell = pkgs.zsh;
        groups.neg.gid = 1000;
    };

    environment.systemPackages = with pkgs; [
        bibata-cursors

        efibootmgr # rule efi boot
        efivar # manipulate efi vars
        os-prober # utility to detect other OSs on a set of drives

        aircrack-ng # stuff for wifi security
        bandwhich # display network utilization per process
        curl
        ethtool # control eth hardware and drivers
        fping # like ping -c1
        geoip # geoip lookup
        hcxdumptool # wpa scanner
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
        netsniff-ng # sniffer
        nettools # controlling the network subsystem in Linux
        nmap # port scanner
        procps # info about processes using /proc
        socat # multipurpose relay
        sshfs # ssh mount
        tcpdump # best friend to show network stuff
        tcptraceroute # traceroute without icmp
        traceroute # basic traceroute
        tshark # sniffer tui
        w3m # cli browser
        wget

        ddrescue # data recovery tool
        foremost # files extact from structure
        hashcat # password recovery
        qFlipper # desktop stuff for flipper zero

        gcc # gnu compiler collection
        gdb # gnu debugger
        hyperfine # command-line benchmarking tool
        ltrace # trace functions
        pkgconf # package compiler and linker metadata toolkit (wrapper script)
        radare2 # free disassembler
        strace # trace system-calls

        git # my favorite dvcs
        git-extras # git extra stuff
        git-filter-repo # quickly rewrite git history
        git-lfs # git extension for large files

        openvpn # gnu/gpl vpn

        chrpath # adjust rpath for ELF
        debugedit # debug info rewrite
        delta
        dump_syms # parsing the debugging information
        elfutils # set of utilities to handle ELF objects
        eza # more modern version of exa ls replacer
        fd # better find
        file # get filetype from content
        patchelf # for fixing up binaries in nix

        vis # minimal editor
        neovim # better vim

        office-code-pro # customized source code pro

        dconf2nix # convert dconf to nix config
        deadnix # scan for dead nix code
        nh # some nice nix commands
        nix-du # nix-du --root /run/current-system/sw/ -s 500MB > result.dot
        nix-index # index for nix-locate
        nix-output-monitor
        nix-tree # Interactive scan current system / derivations for what-why-how depends
        nix-update
        nixos-shell # tool to create vm for current config
        nvd # compare versions: nvd diff /run/current-system result
        statix # static analyzer for nix

        bash-completion
        nix-bash-completions
        nix-zsh-completions

        abduco # cli session detach
        diffutils # classic diff utils
        inotify-tools # shell inotify bindings
        lsof # list open something
        parallel # parallel xargs
        progress # show progress over all coreutils
        psmisc # killall and friends
        pv # pipe viewer
        readline # readline library
        reptyr # move app to another pty, tmux as an example
        ripgrep # better grep
        rlwrap # readline wrapper for everything
        tig # git viewer
        tmux # better screen
        zsh # better shell

        btop # even more fancy top
        htop # fancy top
        iotop # top for iops
        iperf iperf2 # IP bandwidth measurement
        linuxKernel.packages.linux_6_7.turbostat # cpu monitor
        nethogs # network traffic per process
        nvitop # yet another nvidia top
        nvtop-amd # nvidia top
        powertop # watch for power events
        procdump # procdump for linux
        sysstat # sar and friends
        vmtouch # portable file system cache diagnostics and control

        terminus-nerdfont # font for console

        keyd # systemwide key manager

        opensc # libraries and utilities to access smart cards
        p11-kit # loading and sharing PKCS#11 modules
        pass-secret-service # gnome-keyring alternative via paste
        pcscliteWithPolkit # middleware to access a smart card using SCard API (PC/SC)
        pcsctools # tools used to test a PC/SC driver, card or reader
        pkcs11helper # library that simplifies the interaction with PKCS#11 providers
        pwgen # generate passwords

        linuxKernel.packages.linux_6_6.perf
        scx # for cachyos sched

        blktrace # another disk test
        dmraid # Old-style RAID configuration utility
        exfat
        fio # disk test
        gparted # gtk frontend for parted disk manager
        hddtemp # display hard disk temperature
        hdparm # set ata/sata params
        ioping # io latency measuring tool
        mtools # utils for msdos disks
        nvme-cli # nvme manage tools
        ostree # git for os binaries
        parted # cli disk manager

        ddccontrol # ddc control
        ddcutil # rule monitor params
        edid-decode # edid decoder and tester
        read-edid # tool to read and parse edid from monitors
        xcalib # stuff for icc profiles

        dmidecode # extract system/memory/bios info
        lm_sensors # sensors
        pciutils # manipulate pci devices
        usbutils # lsusb
        schedtool # CPU scheduling

        xdg-user-dirs
        xdg-utils

    ];

    programs = {
        atop = { enable = true; };
        dconf = { enable = true; };
        gamemode = { enable = true; };
        mtr = { enable = true; };
        nix-ld = { enable = true; };
        zsh = { enable = true; };
        steam = {
            enable = true;
            remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
            dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        };
    };

    services = {
        acpid.enable = true; # events for some hardware actions
        flatpak.enable = true;
        fwupd.enable = true;
        gvfs.enable = true;
        irqbalance.enable = true;
        openssh.enable = true;
        pcscd.enable = true;
        psd.enable = true;
        udev.packages = with pkgs; [
            android-udev-rules
            yubikey-personalization
        ];
        udisks2.enable = true;
        upower.enable = true;
        vnstat.enable = true;

        # Boot optimizations regarding filesystem:
        # Journald was taking too long to copy from runtime memory to disk at boot
        # set storage to "auto" if you're trying to troubleshoot a boot issue
        journald.extraConfig = ''
            Storage=auto
            SystemMaxFileSize=300M
            SystemMaxFiles=50
        '';
    };

    xdg.portal = {
        enable = true;
        extraPortals = [pkgs.xdg-desktop-portal-gtk];
        config.common.default = "gtk";
    };

    # (man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "23.11"; # Did you read the comment?
    system.autoUpgrade.enable = true;
    system.autoUpgrade.allowReboot = true;
}
