{ config, lib, pkgs, ... }: {
    environment.systemPackages = with pkgs; [ iosevka ];
    services.kmscon = {
        enable = true;
        hwRender = true;
        extraOptions = "--term xterm-256color --font-size 10 --font-name Iosevka";
    };
}
