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
    dxvk # setup script for dxvk
    quickemu # fast and simple vm builder
    winetricks # stuff to install dxvk
    wineWowPackages.unstable # tool to run windows packages
  ];
}
