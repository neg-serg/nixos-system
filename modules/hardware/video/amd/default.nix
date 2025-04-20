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
          Modeline  "3840x2160_240"  533.25  3840 3888 3920 4000  2160 2163 2168 2222 +hsync -vsync (133.3 kHz eP)
          Option	"PreferredMode"	"3840x2160_240"
        '';
      }
    ];
    monitorSection = ''
      Option      "StandbyTime" "0"
      Option      "SuspendTime" "0"
      Option      "OffTime" "0"
      Option      "BlankTime" "0"
    '';
    deviceSection = ''
      Option "VariableRefresh" "false"
      Option "EnablePageFlip"  "off"
    '';
  };
  services.xserver.videoDrivers = ["amdgpu"];
}
