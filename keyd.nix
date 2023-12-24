{ config, lib, pkgs, modulesPath, packageOverrides, ... }:
{
    services.keyd.enable = true;
        services.keyd.keyboards = {
            default = {
                ids = ["*"];
                settings = {
                    main = {
                        capslock = "layer(capslock)";
                    };
                    "capslock:C" = {
                        "0" = "M-0";
                        "h" = "left";
                        "j" = "down";
                        "k" = "up";
                        "l" = "right";
                        "2" = "down";
                        "3" = "up";
                        "[" = "escape";
                        "]" = "insert";
                        "q" = "escape";
                    };
                };
            };
        };
    }
