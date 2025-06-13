{pkgs, ...}: {
  hardware.graphics = {
    enable = true;
  };
  chaotic.mesa-git.enable = false;
  environment = {
    systemPackages = with pkgs; [
      glxinfo
      lact # linux amdgpu controller
      vulkan-extension-layer
      vulkan-tools
      vulkan-validation-layers
    ];
  };
}
