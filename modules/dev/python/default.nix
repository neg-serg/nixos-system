{
  lib,
  pkgs,
  ...
}: {
  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";
    config.allowUnfree = true;

    config.packageOverrides = super: {
      python3-lto = super.python3.override {
        packageOverrides = _pythonSelf: _pythonSuper: {
          enableOptimizations = true;
          enableLTO = true;
          reproducibleBuild = false;
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    python3-lto # different python3 build
  ];
}
