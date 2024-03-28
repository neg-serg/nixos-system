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
        xrandrHeads = [{
            output = "DisplayPort-1";
            monitorConfig = ''
                # Find these values in "/var/log/Xorg.0.log. They will be in this exact format so scroll until you find it.
                Modeline    "3440x1440_175"  1019.75  3440 3488 3520 3600  1440 1443 1453 1619 +hsync -vsync
                Option		"PreferredMode"	"3440x1440_175"
                '';
        }];
        monitorSection=''
            Option      "StandbyTime" "0"
            Option      "SuspendTime" "0"
            Option      "OffTime" "0"
            Option      "BlankTime" "0"
        '';
        deviceSection=''
            Option "VariableRefresh" "false"
            Option "EnablePageFlip" "off"
            #Option "AsyncFlipSecondaries" "false"
        '';
    };
    services.xserver.videoDrivers=["amdgpu"];
}
