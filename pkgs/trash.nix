{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # chez # Chez Scheme (useful for idris)
    # cosmocc # Cosmopolitan (Actually Portable Executable) C/C++ toolchain; use via CC=cosmocc, CXX=cosmoc++
    # flatpak-builder # build flatpaks
    # hashcat # password recovery
    # hddtemp # display hard disk temperature
    # hdparm # set ata/sata params
    # idris2 # Idris2 functional statically-typed programming language that looks cool and compiles to C
    # qFlipper # desktop stuff for flipper zero
  ];
}
