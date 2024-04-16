{ pkgs, ... }: {
    users = {
        users.neg = {
            isNormalUser = true;
            openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPKg+t07fFxKPqtDR3rRpvS6Tc9Rrh5yv7fC5GFrBtyK neg@telfir"
            ];
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
}
