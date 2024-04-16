# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ pkgs, ... }: {
    imports = [
        ./system
        ./hardware
        ./nix
        ./user
        ./pkgs
    ];

    virtualisation.docker.enable = true;

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
        locate = {
            enable = true;
            package = pkgs.plocate;
            localuser = null;
        };
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

    # (man configuration.nix or on https://nixos.org/nixos/options.html).
    system = {
        stateVersion = "23.11"; # Did you read the comment?
        autoUpgrade.enable = true;
        autoUpgrade.allowReboot = true;
    };
}
