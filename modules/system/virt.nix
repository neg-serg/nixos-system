{pkgs, ...}: {
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true; # Create a `docker` alias for podman, to use it as a drop-in replacement
      defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
    };
    docker = {
      enable = false;
      autoPrune = {
        enable = true;
        dates = "weekly";
        flags = ["--all"];
      };
    };

    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        vhostUserPackages = [pkgs.virtiofsd];
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [
            (pkgs.OVMF.override {
              secureBoot = true;
              tpmSupport = true;
            }).fd
          ];
        };
      };
    };
  };

  programs.virt-manager.enable = true;
  services.spice-webdavd.enable = true;

  environment.systemPackages = with pkgs; [
    dive # look into docker image layers
    dxvk # setup script for dxvk
    guestfs-tools # virt-sysprep to prepare image for use
    podman-compose # start group of containers for dev
    podman-tui # status of containers in the terminal
    quickemu # fast and simple vm builder
    winetricks # stuff to install dxvk
    wineWowPackages.unstable # tool to run windows packages
  ];
}
