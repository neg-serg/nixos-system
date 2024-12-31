{pkgs, stable, ...}: {
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
    stable.quickemu # fast and simple vm builder
    wine-staging # tool to run windows packages
    winetricks # stuff to install dxvk
  ];
}
