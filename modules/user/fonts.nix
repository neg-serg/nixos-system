{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
      nerdfonts
  ];
}
