{
  lib,
  pkgs,
  ...
}: {
  services = {
    vnstat.enable = true;
  };
  # Keep vnstatd defaults; hosts may override ExecStart if needed.
}
