{pkgs,...}: {
  environment.systemPackages = with pkgs; [
    dygma # dygma keyboard configurator
  ];
}
