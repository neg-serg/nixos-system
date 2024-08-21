{
  stable,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    ddrescue # data recovery tool
    bpftrace # add tool to trace events via bpf
    foremost # files extact from structure
    gcc # gnu compiler collection
    gdb # gnu debugger
    hexyl # command-line hex editor
    hyperfine # command-line benchmarking tool
    imhex # gui hex editor
    stable.julia # nice language
    ltrace # trace functions
    pkgconf # package compiler and linker metadata toolkit (wrapper script)
    plow # high performance http benchmarking tool
    radare2-cutter # Free and Open Source Reverse Engineering Platform powered by rizin
    radare2 # free disassembler
    strace # trace system-calls
  ];
}
