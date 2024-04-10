{ pkgs, ... }: {
    environment.systemPackages = with pkgs; [
        chrpath # adjust rpath for ELF
        debugedit # debug info rewrite
        dump_syms # parsing the debugging information
        elfutils # set of utilities to handle ELF objects
        patchelf # for fixing up binaries in nix
    ];
}
