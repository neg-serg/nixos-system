{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    python3-lto # optimized Python 3 build (LTO, PGO)
  ];
}
