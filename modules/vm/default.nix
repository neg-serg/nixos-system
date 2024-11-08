{pkgs, master, oldstable, ...}: {
  environment.systemPackages = with pkgs; [
    vmware-horizon-client # vmware remote client
    remmina
  ];
}
