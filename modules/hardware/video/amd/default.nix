{pkgs, ...}: {
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
  };
  services.ollama = {
    enable = true;
    acceleration = "rocm";
  };
  chaotic.mesa-git.enable = true;
  hardware.amdgpu.opencl.enable = true;
  hardware.amdgpu.amdvlk.enable = true;
  environment = {
    variables.AMD_VULKAN_ICD = "RADV";
    systemPackages = with pkgs; [
      clinfo # show info about opencl
      rocmPackages.rocminfo
      rocmPackages.rocm-smi
      glxinfo # show info about glx
      lact # linux amdgpu controller
      (nvtopPackages.amd.override { intel = true; })
      vulkan-extension-layer
      vulkan-tools
      vulkan-validation-layers
    ];
  };
}
