{pkgs,...}: {
  environment.systemPackages = with pkgs; [
    bazecor # dygma keyboard configurator
  ];
}
