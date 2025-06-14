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
      (nvtopPackages.amd.override { intel = true; })
      vulkan-tools
      vulkan-validation-layers
    ];
  };
}
