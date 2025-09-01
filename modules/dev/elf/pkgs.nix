{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    chrpath   # adjust rpath for ELF
    debugedit # debug info rewrite
    dump_syms # parse debugging information
    elfutils  # utilities to handle ELF objects
    patchelf  # fix up binaries in Nix store
  ];
}
