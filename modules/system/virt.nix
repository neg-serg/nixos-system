{pkgs, ...}: {
  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = ["--all"];
    };
  };
  environment.systemPackages = with pkgs; [
    dxvk # for plugins compatibility
    quickemu # fast and simple vm builder
    wineWowPackages.unstable # tool to run windows packages
    dxvk # setup script for dxvk
    winetricks # stuff to install dxvk
  ];
}
