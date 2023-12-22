{ config, lib, pkgs, modulesPath, packageOverrides, ... }:
{
    services.kmscon = {
        enable = false;
        hwRender = true;
        extraOptions = "--term xterm-256color --font-size 12 --font-name Iosevka";
    };
}
