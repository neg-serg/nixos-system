{ pkgs, stable, ... }: {
    environment.systemPackages = with pkgs; [
        gcc # gnu compiler collection
        gdb # gnu debugger
        hexyl # command-line hex editor
        hyperfine # command-line benchmarking tool
        imhex # gui hex editor
        ltrace # trace functions
        pkgconf # package compiler and linker metadata toolkit (wrapper script)
        radare2 # free disassembler
        stable.radare2-cutter # Free and Open Source Reverse Engineering Platform powered by rizin
        strace # trace system-calls
    ];
}
