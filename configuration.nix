# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, lib, pkgs, modulesPath, packageOverrides, inputs, ... }: {
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

        ./pkgs.nix
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
            max-jobs = 20;
            cores = 32;
        };
        gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 21d";
        };
    };
    nixpkgs.config.allowUnfree = true;

    systemd = {
        coredump.enable = true;
        extraConfig = '' DefaultTimeoutStopSec=10s '';
        packages = [pkgs.packagekit];
    };

    security = {
        pam = {
            loginLimits = [
                {domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited";}
                {domain = "@audio"; item = "rtprio"; type = "-"; value = "95";}
                {domain = "@audio"; item = "nice"; type = "-"; value = "-19";}
                {domain = "@realtime"; item = "rtprio"; type = "-"; value = "98";}
                {domain = "@realtime"; item = "memlock"; type = "-"; value = "unlimited";}
                {domain = "@realtime"; item = "nice"; type = "-"; value = "-11";}
                {domain = "@gamemode"; item = "nice"; type = "-"; value = "-10";}
            ];
        };
        polkit.enable = true;
        polkit.extraConfig = ''
            polkit.addRule(function(action, subject) {
              if (action.id == "org.debian.pcsc-lite.access_pcsc" &&
                subject.isInGroup("wheel")) {
                return polkit.Result.YES;
              }
            });
        '';
        rtkit.enable = true; # rtkit recommended for pipewire
        sudo.execWheelOnly = true;
        sudo.wheelNeedsPassword = false;
    };

    documentation.doc.enable = false;
    documentation.info.enable = false;

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
        nix-ld = { enable = true; };
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
        udev.packages = with pkgs; [ android-udev-rules ];
        udisks2.enable = true;
        upower.enable = true;
        vnstat.enable = true;

        logind = { extraConfig = ''
            IdleAction=ignore
        ''; };

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
        extraPortals = with pkgs; [ xdg-desktop-portal xdg-desktop-portal-gtk ];
        config.common.default = "gtk";
    };

    # (man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "23.11"; # Did you read the comment?
    system.autoUpgrade.enable = true;
    system.autoUpgrade.allowReboot = true;
}
