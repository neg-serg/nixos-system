{
  pkgs,
  stable,
  ...
}: {
  environment.systemPackages = with pkgs; [
    stable.bpftrace # add tool to trace events via bpf
    ddrescue # data recovery tool
    foremost # files extact from structure
    gcc # gnu compiler collection
    gdb # gnu debugger
    hexyl # command-line hex editor
    hyperfine # command-line benchmarking tool
    imhex # gui hex editor
    julia # nice language
    ltrace # trace functions
    pkgconf # package compiler and linker metadata toolkit (wrapper script)
    plow # high performance http benchmarking tool
    stable.radare2-cutter # Free and Open Source Reverse Engineering Platform powered by rizin
    radare2 # free disassembler
    strace # trace system-calls
  ];
}
