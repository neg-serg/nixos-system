{pkgs, ...}: {
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true; # 32-bit userspace for Steam/Wine
      setLdLibraryPath = true; # Provide LD_LIBRARY_PATH for legacy GL apps
      extraPackages = with pkgs; [
        rocmPackages.clr.icd
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
    amdgpu.opencl.enable = true;
    amdgpu.amdvlk.enable = true;
  };
  chaotic.mesa-git.enable = true;
  environment = {
    variables.AMD_VULKAN_ICD = "RADV";
    systemPackages = with pkgs; [
      clinfo # show info about opencl
      rocmPackages.rocminfo
      rocmPackages.rocm-smi
      glxinfo # show info about glx
      libva-utils # vainfo, encode/decode probing
      vdpauinfo
      lact # linux amdgpu controller
      (nvtopPackages.amd.override {intel = true;})
      vulkan-extension-layer
      vulkan-tools
      vulkan-validation-layers
    ];
  };
}
