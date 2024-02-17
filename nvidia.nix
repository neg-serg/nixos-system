{ pkgs, ... }: {
    hardware.opengl={
        enable=true;
        driSupport=true;
        driSupport32Bit=true;
    };
    boot.extraModprobeConfig=''
        options nouveau modeset=0
        options nvidia NVreg_RegistryDwords="PowerMizerEnable=0x1; PerfLevelSrc=0x2222; PowerMizerLevel=0x3; PowerMizerDefault=0x3; PowerMizerDefaultAC=0x3"
    '';
    environment={
        systemPackages=with pkgs; [
            glxinfo
            vulkan-extension-layer
            vulkan-tools
            vulkan-validation-layers
        ];
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
