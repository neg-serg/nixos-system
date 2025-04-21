{pkgs, ...}: {
  hardware.graphics = {
    enable = true;
  };
  environment = {
    systemPackages = with pkgs; [
      glxinfo
      lact # linux amdgpu controller
      vulkan-extension-layer
      vulkan-tools
      vulkan-validation-layers
    ];
  };
  services.xserver = {
    enable = true;
    xrandrHeads = [
      {
        output = "DisplayPort-1";
        monitorConfig = ''
          # Find these values in "$HOME/.local/share/xorg/Xorg.0.log They will be in this exact format so scroll until you find it.
          Modeline "3840x2160x240.0"  2315.95  3840 3936 3968 4096  2160 2166 2176 2356 +hsync -vsync
          Option	"PreferredMode"	"3840x2160x240.0"
        '';
      }
    ];
    monitorSection = ''
      Option      "StandbyTime"     "0"
      Option      "SuspendTime"     "0"
      Option      "OffTime"         "0"
      Option      "BlankTime"       "0"
    '';
    deviceSection = ''
      Option "VariableRefresh"      "false"
      Option "EnablePageFlip"       "off"
    '';
  };
  services.xserver.videoDrivers = ["amdgpu"];
}
