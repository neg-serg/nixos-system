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
            # Find these values in "/var/log/Xorg.0.log. They will be in this exact format so scroll until you find it.
            #Modeline    ""3440x1440"x175.0  1019.75  3440 3488 3520 3600  1440 1443 1453 1619 +hsync -vsync"
            Option		"PreferredMode"	"3440x1440_175.0"
            Option      "StandbyTime" "0"
            Option      "SuspendTime" "0"
            Option      "OffTime" "0"
            Option      "BlankTime" "0"
        '';
        deviceSection=''
            Option "VariableRefresh" "false"
            #Option "AsyncFlipSecondaries" "false"
            #Option "EnablePageFlip" "off"
        '';
    };
    services.xserver.videoDrivers=["amdgpu"];
}
