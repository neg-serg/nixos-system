{pkgs, ...}: {
  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = ["--all"];
    };
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [(pkgs.OVMF.override {
          secureBoot = true;
          tpmSupport = true;
        }).fd];
      };
    };
  };

  services.spice-webdavd.enable = true;
  virtualisation.libvirtd.qemu.vhostUserPackages = [ pkgs.virtiofsd ];

  environment.systemPackages = with pkgs; [
    dxvk # setup script for dxvk
    quickemu # fast and simple vm builder
    guestfs-tools # virt-sysprep to prepare image for use
    winetricks # stuff to install dxvk
    wineWowPackages.unstable # tool to run windows packages
  ];
}
