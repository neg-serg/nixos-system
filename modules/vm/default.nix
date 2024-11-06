{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    vmware-horizon-client # vmware remote client
  ];
}
