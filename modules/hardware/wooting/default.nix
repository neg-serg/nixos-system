{
  pkgs,
  lib,
  config,
  ...
}:
with {
  main = lib.mkIf (config.networking.hostName == "telfir");
}; {
  environment.systemPackages = with pkgs;
    main [
      wootility
      wooting-udev-rules
    ];
}
