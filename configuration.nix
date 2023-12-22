# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, lib, pkgs, modulesPath, packageOverrides, ... }:
{
    imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
        ./filesystems.nix
        ./networking.nix
        ./nvidia.nix
        ./udev-rules.nix
        ./python-lto.nix
        #./kmscon.nix
    ];
    nix.extraOptions = ''experimental-features = nix-command flakes'';
    nixpkgs.config.allowUnfree = true;

    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
        systemd-boot.consoleMode = "auto";
    };
    boot.initrd = {
        availableKernelModules = [
            "nvidia"
            "nvidia_drm"
            "nvidia_modeset"
            "nvidia_uvm"
            "nvme"
            "sd_mod"
            "usbhid"
            "usb_storage"
            "xhci_hcd"
            "xhci_pci"
        ];
        kernelModules = ["dm-snapshot"];
    };
    boot.kernelModules = ["kvm-amd"];
    boot.kernelParams = [
        "rootflags=rw,relatime,lazytime,background_gc=on,discard,no_heap,user_xattr,inline_xattr,acl,inline_data,inline_dentry,flush_merge,extent_cache,mode=adaptive,active_logs=6,alloc_mode=default,fsync_mode=posix"

        "acpi_osi=!"
        "acpi_osi=Linux"
        "amd_iommu=on"
        "audit=0"
        "biosdevname=1"
        "cryptomgr.notests"
        "iommu=pt"
        "l1tf=off"
        "loglevel=0"
        "mds=off"
        "mitigations=off"
        "net.ifnames=0"
        "noibpb"
        "noibrs"
        "noreplace-smp"
        "nospec_store_bypass_disable"
        "nospectre_v1"
        "nospectre_v2"
        "no_stf_barrier"
        "no_timer_check"
        "nowatchdog"
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
    ];
    boot.extraModulePackages = [];
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    time.timeZone = "Europe/Moscow";
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
        LC_ADDRESS = "ru_RU.UTF-8";
        LC_IDENTIFICATION = "ru_RU.UTF-8";
        LC_MEASUREMENT = "ru_RU.UTF-8";
        LC_MONETARY = "ru_RU.UTF-8";
        LC_NAME = "ru_RU.UTF-8";
        LC_NUMERIC = "ru_RU.UTF-8";
        LC_PAPER = "ru_RU.UTF-8";
        LC_TELEPHONE = "ru_RU.UTF-8";
        LC_TIME = "ru_RU.UTF-8";
    };

    services.xserver = {
        enable = true; # Enable the X11 windowing system.
        exportConfiguration = true;
        layout = "us,ru";
        xkbVariant = "";
        xkbOptions = "grp:alt_shift_toggle";
        libinput.enable = true; # Enable touchpad support (enabled default in most desktopManager).
        displayManager = {
            defaultSession = "negwm";
            session = [{manage="desktop"; name="negwm"; start=''$HOME/.xsession'';}];
            lightdm = {
                enable = true;
                greeters.gtk = {
                    enable = true;
                    theme.package = pkgs.flat-remix-gtk;
                    iconTheme.package = pkgs.flat-remix-icon-theme;
                    theme.name = "Flat-Remix-GTK-Dark-Blue";
                    iconTheme.name = "Flat-Remix-Dark-Blue";
                    cursorTheme = {
                        package = pkgs.bibata-cursors;
                        name = "Bibata-Modern-Ice";
                    };
                };
            };
        };
    };

    systemd.packages = [pkgs.packagekit];
    services.pcscd.enable = true;
    systemd.services."getty@tty1".enable = false;
    systemd.services."autovt@tty1".enable = false;
    systemd.services.keyd = {
        description = "key remapping daemon";
        requires = ["local-fs.target"];
        after = ["local-fs.target"];
        serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.keyd}/bin/keyd";
        };
        wantedBy = ["sysinit.target"];
    };

    environment.etc."keyd/keyd.conf".text = lib.mkForce ''
        [ids]
        *

        [main]
        capslock = layer(capslock)

        [capslock:C]
        0 = M-0
        h = left
        j = down
        k = up
        l = right
        2 = down
        3 = up
        [ = escape
        ] = insert
        q = escape
        '';

    security.polkit.enable = true;
    security.sudo.extraRules= [ {
        users = [ "privileged_user" ];
            # "SETENV" # Adding the following could be a good idea
            commands=[{command="ALL" ; options= ["NOPASSWD"];}];
        }
    ];
    security.pam = {
        services.lightdm.enableGnomeKeyring = true;
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
        PATH = ["${XDG_BIN_HOME}"];
        ZDOTDIR = "$HOME/.config/zsh";
    };

    fonts.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        liberation_ttf
        iosevka
    ];

    services.printing.enable = false;
    hardware.pulseaudio.enable = false;
    # Enable the OpenRazer driver for my Razer stuff
    hardware.openrazer.enable = true;
    security.rtkit.enable = true; # rtkit is optional but recommended
        services.pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
            jack.enable = true;
        };

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.neg = {
        packages = with pkgs; [
            python3-lto
            pinentry-gnome
        ];
        isNormalUser = true;
        description = "Neg";
        extraGroups = [
            "audio"
            "neg"
            "networkmanager"
            "systemd-journal"
            "video"
            "openrazer"
            "wheel"
            "tty"
            "input"
        ];
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

        expect

        git
        git-extras

        delta
        fd
        file
        neovim

        nix-du # nix-du --root /run/current-system/sw/ -s 500MB > result.dot
        nix-index
        nix-update
        nix-output-monitor
        nvd

        abduco
        ripgrep
        tig
        tmux
        zsh

        htop
        iotop

        terminus-nerdfont

        keyd

        pass-secret-service

        gnomeExtensions.appindicator
        gnome.gnome-settings-daemon
    ];

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
    };

    services = {
        dbus.packages = [ pkgs.gcr pkgs.gnome.gnome-keyring ];
        flatpak.enable = true;
        openssh.enable = true;
        udev.packages = with pkgs; [gnome.gnome-settings-daemon];
        gnome.gnome-keyring.enable = true;
    };

    xdg.portal = {
        enable = true;
        extraPortals = [pkgs.xdg-desktop-portal-gnome pkgs.gnome.gnome-keyring];
        config.common.default = "gnome";
    };

    # (man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "23.11"; # Did you read the comment?
    system.copySystemConfiguration = true;
    system.autoUpgrade.enable = true;
    system.autoUpgrade.allowReboot = true;
}
