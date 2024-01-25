{ config, lib, pkgs, modulesPath, packageOverrides, ... }: {
    nixpkgs = {
        hostPlatform = lib.mkDefault "x86_64-linux";
        config.allowUnfree = true;

        config.packageOverrides = super: {
            python3-lto = super.python3.override {
                packageOverrides = python-self: python-super: {
                    enableOptimizations = true;
                    enableLTO = true;
                    reproducibleBuild = false;
                };
            };
        };
    };
}
