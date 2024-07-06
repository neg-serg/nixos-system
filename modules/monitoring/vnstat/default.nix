{
  lib,
  pkgs,
  ...
}: {
  services = {
    vnstat.enable = true;
  };
  systemd = {
    services.vnstat = {
      serviceConfig.ExecStart = lib.mkForce "${pkgs.vnstat}/bin/vnstatd -n --alwaysadd 1";
    };
  };
}
