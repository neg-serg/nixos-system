{unstable, ...}: {
  environment.systemPackages = with unstable; [
    vmware-horizon-client # vmware remote client
  ];
}
