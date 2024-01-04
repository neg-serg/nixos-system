# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, lib, pkgs, modulesPath, packageOverrides, inputs, ... }:
{
    imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
        ./boot.nix
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
    nix.extraOptions = ''experimental-features = nix-command flakes'';
    nix.settings = {
        trusted-users = ["root" "neg"];
        substituters = ["https://ezkea.cachix.org" "https://nix-gaming.cachix.org"];
        trusted-public-keys = [
            "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
            "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        ];
    };
    nixpkgs.config.allowUnfree = true;

    systemd.packages = [pkgs.packagekit];
    services.pcscd.enable = true;
    services.gvfs.enable = true;
    services.udisks2.enable = true;
    systemd.services."getty@tty1".enable = false;
    systemd.services."autovt@tty1".enable = false;
    security.polkit.enable = true;
    security.pam = {
        loginLimits = [{domain = "@users"; item = "rtprio"; type = "-"; value = 1;}];
    };

    # This is using a rec (recursive) expression to set and access XDG_BIN_HOME within the expression
    # For more on rec expressions see https://nix.dev/tutorials/first-steps/nix-language#recursive-attribute-set-rec
    environment.sessionVariables = rec {

        XDG_CACHE_HOME = "$HOME/.cache";
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_DATA_HOME = "$HOME/.local/share";
        XDG_STATE_HOME = "$HOME/.local/state";
        XDG_BIN_HOME = "$HOME/.local/bin";

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

    hardware.pulseaudio.enable = false;
    hardware.bluetooth.enable = true;
    powerManagement.cpuFreqGovernor = "performance";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    hardware.openrazer.enable = true; # Enable the OpenRazer driver for my Razer stuff
    security.rtkit.enable = true; # rtkit is optional but recommended
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
    };

    users.users.neg = {
        packages = with pkgs; [pam_u2f python3-lto];
        isNormalUser = true;
        description = "Neg";
        extraGroups = ["audio" "neg" "networkmanager" "systemd-journal" "video" "openrazer" "wheel" "input"];
    };

    users.defaultUserShell = pkgs.zsh;
    users.groups.neg.gid = 1000;
    environment.systemPackages = with pkgs; [
        flat-remix-gtk
        flat-remix-icon-theme
        bibata-cursors

        curl
        wget

        gcc
        gdb

        expect # do tty stuff noninteractively

        git
        git-extras

        openvpn # gnu/gpl vpn

        patchelf # for fixing up binaries in nix
        delta
        eza # more modern version of exa ls replacer
        fd # better find
        file # get filetype from content

        neovim

        deadnix # scan for dead nix code
        nh # some nice nix commands
        nix-du # nix-du --root /run/current-system/sw/ -s 500MB > result.dot
        nix-index
        nix-output-monitor
        nix-tree # Interactive scan current system / derivations for what-why-how depends
        nix-update
        nvd # compare versions: nvd diff /run/current-system result
        statix # static analyzer for nix

        abduco # cli session detach
        parallel # parallel xargs
        psmisc # killall and friends
        ripgrep # better grep
        tig # git viewer
        tmux # better screen
        zsh # better shell

        htop # fancy top
        iotop # top for iops
        btop # even more fancy top

        terminus-nerdfont # font for console

        keyd # systemwide key manager

        pass-secret-service

        linuxKernel.packages.linux_6_6.perf
        scx # for cachyos sched

        gnomeExtensions.appindicator
        gnome.gnome-settings-daemon

        gparted # gtk frontend for parted disk manager
        exfat

        telegram-desktop_git
    ];

    systemd.extraConfig = ''
        DefaultTimeoutStopSec=10s
    '';

    # Boot optimizations regarding filesystem:
    # Journald was taking too long to copy from runtime memory to disk at boot
    # set storage to "auto" if you're trying to troubleshoot a boot issue
    services.journald.extraConfig = ''
        Storage=auto
        SystemMaxFileSize=300M
        SystemMaxFiles=50
    '';

    environment.shells = with pkgs; [zsh];

    programs = {
        dconf = { enable = true; };
        mtr = { enable = true; };
        zsh = { enable = true; };
        steam = {
            enable = true;
            remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
            dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        };
    };

    services = {
        flatpak.enable = true;
        openssh.enable = true;
        udev.packages = with pkgs; [gnome.gnome-settings-daemon yubikey-personalization];
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
