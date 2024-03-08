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
        #screenSection=''Option "metamodes" "3440x1440_175 +0+0"'';
        monitorSection=''
            #Identifier	"DisplayPort-0" # Not sure if this needs to be the same as in "xrandr -q".
            #Modeline   "3440x1440_175"x0.0  349.25  3440 3488 3520 3600  1440 1443 1453 1618 +hsync -vsync (97.0 kHz eP) # Find these values in "/var/log/Xorg.0.log. They will be in this exact format so scroll until you find it.
            #Option		"PreferredMode"	"3440x1440_175"
            Option      "StandbyTime" "0"
            Option      "SuspendTime" "0"
            Option      "OffTime" "0"
            Option      "BlankTime" "0"
        '';
        deviceSection=''
            Option "VariableRefresh" "false"
        '';
    };
    services.xserver.videoDrivers=["amdgpu"];
}
