{ config, lib, pkgs, modulesPath, packageOverrides, ... }: {
    services.openssh = {
        enable = true;
        settings.PasswordAuthentication = false;
        settings.KbdInteractiveAuthentication = false;
        settings.PermitRootLogin = "no";
    };
}
