{pkgs, ...}: {
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
  };
  chaotic.mesa-git.enable = true;
  hardware.amdgpu.amdvlk.enable = true;
  environment = {
    variables.AMD_VULKAN_ICD = "RADV";
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
