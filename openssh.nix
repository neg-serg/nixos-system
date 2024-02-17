{ config, lib, pkgs, modulesPath, packageOverrides, ... }: {
    services.openssh = {
        enable = true;
        settings = {
            PasswordAuthentication = false;
            KbdInteractiveAuthentication = false;
            PermitRootLogin = "no";
        };
    };
}
