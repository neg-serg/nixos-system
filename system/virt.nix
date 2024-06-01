{pkgs, ...}: {
  virtualisation.docker.enable = true;
  environment.systemPackages = with pkgs; [
      dxvk # for plugins compatibility
      wine-staging # tool to run windows packages
      winetricks # stuff to install dxvk
  ];
}
