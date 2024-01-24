{ config, lib, pkgs, ... }: {
    hardware.opengl={
        enable=true;
        driSupport=true;
        driSupport32Bit=true;
    };
    boot.extraModprobeConfig=''
        options nouveau modeset=0
        options nvidia NVreg_PreserveVideoMemoryAllocations=1 NVreg_TemporaryFilePath=/home/neg/.local/share/tmp
    '';
    environment={
        systemPackages=with pkgs; [glxinfo];
        variables={ 
            __GL_GSYNC_ALLOWED="0"; 
        };
    };

    services.xserver={
        screenSection=''Option         "metamodes" "3440x1440_175 +0+0 {AllowGSYNCCompatible=Off}"'';
        monitorSection=''
            Option "StandbyTime" "0"
            Option "SuspendTime" "0"
            Option "OffTime" "0"
            Option "BlankTime" "0"
        '';
    };
    services.xserver.videoDrivers=["nvidia"];
    hardware.nvidia={
        open=false; # Currently alpha-quality/buggy, so false is currently the recommended setting.
        nvidiaSettings=true;
    };
}
