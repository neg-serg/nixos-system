# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, lib, pkgs, modulesPath, kexec_enabled, inputs, ... }: {
    imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
        ./appimage.nix
        ./boot.nix
        ./filesystems.nix
        ./kernel.nix
        ./keyd.nix
        ./locale.nix
        ./networking.nix
        ./nixindex.nix
        ./amd.nix
        ./pkgs.nix
        ./python-lto.nix
        ./session.nix
        ./udev-rules.nix
        ./vnstat.nix
        ./pipewire.nix
        #./wayland.nix
	    #./greetd.nix
    ];
    nix = {
        settings = {
            experimental-features = [
                "auto-allocate-uids"
                "ca-derivations"
                "flakes"
                "nix-command"
            ];
            trusted-users = ["root" "neg"];
            substituters = [
                "https://ezkea.cachix.org"
                "https://nix-gaming.cachix.org"
            ];
            trusted-public-keys = [
                "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
                "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
            ];
            max-jobs = 20;
            cores = 32;
        };
        gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 21d";
        };
        registry.nixpkgs.flake = inputs.nixpkgs;
        registry.stable.flake = inputs.nixpkgs-stable;
    };
    nixpkgs.config.allowUnfree = true;

    systemd = {
        coredump.enable = true;
        extraConfig = '' DefaultTimeoutStopSec=10s '';
        watchdog.rebootTime = "0";
        packages = [
            pkgs.packagekit
        ];
    };

    security = {
        pam = {
            loginLimits = [
                {domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited";}
                {domain = "@users"; item = "rtprio"; type = "-"; value = 1;}
                {domain = "@audio"; item = "rtprio"; type = "-"; value = "95";}
                {domain = "@audio"; item = "nice"; type = "-"; value = "-19";}
                {domain = "@realtime"; item = "rtprio"; type = "-"; value = "98";}
                {domain = "@realtime"; item = "memlock"; type = "-"; value = "unlimited";}
                {domain = "@realtime"; item = "nice"; type = "-"; value = "-11";}
                {domain = "@gamemode"; item = "nice"; type = "-"; value = "-10";}
            ];
            services = {
                login.u2fAuth = true;
                sudo.u2fAuth = true;
            };
        };
        polkit.enable = true;
        rtkit.enable = true; # rtkit recommended for pipewire
        sudo.extraRules = [{
              commands = [{
                  command = "${pkgs.systemd}/bin/systemctl suspend";
                  options = ["NOPASSWD"];
              }{
                  command = "${pkgs.systemd}/bin/reboot";
                  options = ["NOPASSWD"];
              }{
                  command = "${pkgs.systemd}/bin/poweroff";
                  options = ["NOPASSWD"];
              }];
              groups = ["wheel"];
        }];
        sudo.execWheelOnly = true;
        sudo.wheelNeedsPassword = true;
        protectKernelImage = if kexec_enabled == false then true else false;
    };

    virtualisation.docker.enable = true;

    documentation = {
        doc.enable = false;
        dev.enable = false;
        info.enable = false;
    };

    environment.wordlist.enable = true; # to make "look" utility work
    environment.shells = with pkgs; [zsh];
    # This is using a rec (recursive) expression to set and access XDG_BIN_HOME within the expression
    # For more on rec expressions see https://nix.dev/tutorials/first-steps/nix-language#recursive-attribute-set-rec
    environment.sessionVariables = {
        XDG_CACHE_HOME = "$HOME/.cache";
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_DATA_HOME = "$HOME/.local/share";
        XDG_DESKTOP_DIR = "$HOME/.local/desktop";
        XDG_DOCUMENTS_DIR = "$HOME/doc/";
        XDG_DOWNLOAD_DIR = "$HOME/dw";
        XDG_MUSIC_DIR = "$HOME/music";
        XDG_PICTURES_DIR = "$HOME/pic";
        XDG_PUBLICSHARE_DIR = "$HOME/1st_level/upload/share";
        XDG_STATE_HOME = "$HOME/.local/state";
        XDG_TEMPLATES_DIR = "$HOME/1st_level/templates";
        XDG_VIDEOS_DIR = "$HOME/vid";
        ZDOTDIR = "$HOME/.config/zsh";
    };

    environment.variables = {
        ASPELL_CONF = ''
            per-conf $XDG_CONFIG_HOME/aspell/aspell.conf;
            personal $XDG_CONFIG_HOME/aspell/en_US.pws;
            repl $XDG_CONFIG_HOME/aspell/en.prepl;
        '';
        HISTFILE = "$XDG_DATA_HOME/bash/history";
        INPUTRC = "$XDG_CONFIG_HOME/readline/inputrc";
        LESSHISTFILE = "$XDG_CACHE_HOME/lesshst";
        WGETRC = "$XDG_CONFIG_HOME/wgetrc";
    };

    # Tell p11-kit to load/proxy opensc-pkcs11.so, providing all available slots
    # (PIN1 for authentication/decryption, PIN2 for signing).
    environment.etc."pkcs11/modules/opensc-pkcs11".text = ''
        module: ${pkgs.opensc}/lib/opensc-pkcs11.so
    '';

    hardware.i2c.enable = true;
    hardware.pulseaudio.enable = false;
    hardware.bluetooth = {
        enable = true;
        powerOnBoot = false;
        settings = {General.Enable = "Source,Sink,Media,Socket";};
    };
    powerManagement.cpuFreqGovernor = "performance";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    hardware.enableAllFirmware = true; # Enable all the firmware
    hardware.enableRedistributableFirmware = true;
    hardware.openrazer.enable = true; # Enable the OpenRazer driver for my Razer stuff

    nixpkgs.config.packageOverrides = pkgs: {
      steam = pkgs.steam.override {
          extraPkgs = pkgs: with pkgs; [
              keyutils
              libkrb5
              libpng
              libpulseaudio
              libvorbis
              stdenv.cc.cc.lib
              xorg.libXcursor
              xorg.libXi
              xorg.libXinerama
              xorg.libXScrnSaver
          ];
      };
    };

    users = {
        users.neg = {
            isNormalUser = true;
            description = "Neg";
            extraGroups = [
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

    programs = {
        atop = { enable = true; };
        gamemode = { enable = true; };
        mtr = { enable = true; };
        nano = { enable = false; }; # I hate nano to be honest
        zsh = { enable = true; };
        ssh = {
            startAgent = true;
            # agentPKCS11Whitelist = "/nix/store/*";
            # or specific URL if you're paranoid
            # but beware this can break if you don't have exactly matching opensc versions
            # between your main config and home-manager channel
            agentPKCS11Whitelist = "${pkgs.opensc}/lib/opensc-pkcs11.so";
        };
        steam = {
            enable = true;
            dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
            gamescopeSession.enable = true;
            remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        };
    };

    services = {
        acpid.enable = true; # events for some hardware actions
        adguardhome.enable = true;
        autorandr.enable = true;
        avahi = {enable = true; nssmdns4 = true;};
        chrony.enable = true;
        earlyoom.enable = false; # may need it for notebook
        fwupd.enable = true;
        gvfs.enable = true;
        irqbalance.enable = false;
        locate = { enable = true; package = pkgs.plocate; };
        logind = { extraConfig = '' IdleAction=ignore ''; };
        openssh.enable = true;
        pcscd.enable = true;
        psd.enable = true;
        sysprof.enable = false; # gnome profiler ?
        udev.packages = with pkgs; [ android-udev-rules ];
        udisks2.enable = true;
        upower.enable = true;
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
        extraPortals = with pkgs; [
            xdg-desktop-portal
            xdg-desktop-portal-gtk
            xdg-desktop-portal-wlr
        ];
        wlr = { enable = true; };
        config.common.default = "wlr";
    };

    # (man configuration.nix or on https://nixos.org/nixos/options.html).
    system = {
        stateVersion = "23.11"; # Did you read the comment?
        autoUpgrade.enable = true;
        autoUpgrade.allowReboot = true;
    };
}
