{ pkgs, ... }: {
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
}
