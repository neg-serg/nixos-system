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
        ./gnome-keyring.nix
    ];
    nix.extraOptions = ''experimental-features = nix-command flakes'';

    nixpkgs = {
        hostPlatform = lib.mkDefault "x86_64-linux";
        config.allowUnfree = true;

        config.packageOverrides = super: {
          python3-lto = super.python3.override {
            packageOverrides = python-self: python-super: {
                enableOptimizations = true;
                enableLTO = true;
                reproducibleBuild = false;
            };
          };
        };
    };

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "usb_storage" "usbhid" "sd_mod"];
    boot.initrd.kernelModules = ["dm-snapshot"];
    boot.kernelModules = ["kvm-amd"];
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

    services.kmscon = {
      enable = false;
      hwRender = true;
      extraOptions = "--term xterm-256color --font-size 12 --font-name Iosevka";
    };

    systemd.packages = [pkgs.packagekit];
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
    security.pam.loginLimits = [
        {domain = "@users"; item = "rtprio"; type = "-"; value = 1;}
    ];

    # This is using a rec (recursive) expression to set and access XDG_BIN_HOME within the expression
    # For more on rec expressions see https://nix.dev/tutorials/first-steps/nix-language#recursive-attribute-set-rec
    environment.sessionVariables = rec {
        XDG_CACHE_HOME  = "$HOME/.cache";
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_DATA_HOME   = "$HOME/.local/share";
        XDG_STATE_HOME  = "$HOME/.local/state";
        XDG_BIN_HOME    = "$HOME/.local/bin";
        PATH = [ "${XDG_BIN_HOME}" ];
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
        packages = with pkgs; [python3-lto];
        isNormalUser = true;
        description = "Neg";
        extraGroups = [ 
            "audio" 
            "neg"
            "networkmanager"
            "systemd-journal" 
            "video" 
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

        git
        git-extras

        delta
        fd
        neovim
        nix-index
        ripgrep
        tig
        tmux
        zsh

        htop
        iotop

        terminus-nerdfont

        keyd
    ];

    # Boot optimizations regarding filesystem:
    # Journald was taking too long to copy from runtime memory to disk at boot
    # set storage to "auto" if you're trying to troubleshoot a boot issue
    services.journald.extraConfig = ''
      Storage=auto
      SystemMaxFileSize=300M
      SystemMaxFiles=50
    '';

    environment.shells = with pkgs; [ zsh ];
    programs.dconf.enable = true;
    programs.mtr.enable = true;
    programs.zsh = { enable = true; };
    services.openssh.enable = true;
    services.flatpak.enable = true;
    # gnome daemons
    services.udev.packages = with pkgs; [gnome.gnome-settings-daemon];

    xdg.portal = {
        enable = true;
        extraPortals = [pkgs.xdg-desktop-portal-gtk];
        config.common.default = "gtk";
    };

    # (man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "23.11"; # Did you read the comment?
}
