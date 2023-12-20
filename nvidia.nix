{ config, lib, pkgs, ... }:
{
    hardware.opengl={
        enable=true;
        driSupport=true;
        driSupport32Bit=true;
    };
    boot.blacklistedKernelModules=[ "nouveau" ];
    boot.extraModprobeConfig=''
        blacklist nouveau
        options nouveau modeset=0
        '';

    environment={
        systemPackages=with pkgs; [glxinfo];
        variables={ __GL_GSYNC_ALLOWED="0"; };
    };

    services.xserver={screenSection=''Option         "metamodes" "3440x1440_175 +0+0 {AllowGSYNCCompatible=Off}"'';};
    services.xserver.videoDrivers=["nvidia"];
    hardware.nvidia={
        modesetting.enable=true; # Modesetting is required.
        # Nvidia power management. Experimental, and can cause sleep/suspend to fail. powerManagement.enable=false;
        # Fine-grained power management. Turns off GPU when not in use.
        # Experimental and only works on modern Nvidia GPUs (Turing or newer).
        powerManagement.finegrained=false;
        open=false; # Currently alpha-quality/buggy, so false is currently the recommended setting.
        nvidiaSettings=true;
    };
}
