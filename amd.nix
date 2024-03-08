{ pkgs, ... }: {
    hardware.opengl={
        enable=true;
        driSupport=true;
        driSupport32Bit=true;
    };
    environment={
        systemPackages=with pkgs; [
            glxinfo
            vulkan-extension-layer
            vulkan-tools
            vulkan-validation-layers
        ];
    };
    services.xserver={
        enable=true;
        screenSection=''Option "metamodes" "3440x1440_175 +0+0"'';
        monitorSection=''
            Option "StandbyTime" "0"
            Option "SuspendTime" "0"
            Option "OffTime" "0"
            Option "BlankTime" "0"
        '';
        deviceSection=''
            Option "VariableRefresh" "true"
        '';
    };
    services.xserver.videoDrivers=["amdgpu"];
}
