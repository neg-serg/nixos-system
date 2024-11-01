{pkgs, lib, config, ...}: with {
  is_main = lib.mkIf (config.networking.hostName == "telfir");
}; {
  environment.systemPackages = with pkgs; is_main [
    bazecor # dygma keyboard configurator
  ];
}
