# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, lib, pkgs, modulesPath, kexec_enabled, inputs, ... }: {
    imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
        ./boot.nix
        ./appimage.nix
        ./filesystems.nix
        ./kernel.nix
        ./keyd.nix
        ./locale.nix
        ./networking.nix
        ./nixindex.nix
        ./nvidia.nix
        ./pkgs.nix
        ./python-lto.nix
        ./session.nix
        ./udev-rules.nix
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
    };
    nixpkgs.config.allowUnfree = true;
    nix.registry.nixpkgs.flake = inputs.nixpkgs;
    nix.registry.stable.flake = inputs.nixpkgs-stable;

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
    environment.sessionVariables = { ZDOTDIR = "$HOME/.config/zsh"; };

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
        # lowLatency = { enable = true; quantum = 128; rate = 48000; };
    };

    # # bluetooth support(maybe not needed, check it later)
    # environment.etc = {
    #     "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
    #         bluez_monitor.properties = {
    #             ["bluez5.enable-sbc-xq"] = true,
    #             ["bluez5.enable-msbc"] = true,
    #             ["bluez5.enable-hw-volume"] = true,
    #             ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
    #         }
    #     '';
    # };

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
        hyprland = {
            enable = true; # Install the packages from nixpkgs
            xwayland.enable = true; # Whether to enable XWayland
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
        openssh.enable = true;
        pcscd.enable = true;
        psd.enable = true;
        sysprof.enable = false; # gnome profiler ?
        udev.packages = with pkgs; [ android-udev-rules ];
        udisks2.enable = true;
        upower.enable = true;
        vnstat.enable = true;
        logind = { extraConfig = '' IdleAction=ignore ''; };
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
        extraPortals = with pkgs; [xdg-desktop-portal xdg-desktop-portal-gtk];
        config.common.default = "gtk";
    };

    # (man configuration.nix or on https://nixos.org/nixos/options.html).
    system = {
        stateVersion = "23.11"; # Did you read the comment?
        autoUpgrade.enable = true;
        autoUpgrade.allowReboot = true;
    };
}
