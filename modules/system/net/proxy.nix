{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    nekoray # proxy manager
  ];
}
