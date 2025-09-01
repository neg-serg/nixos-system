{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    abduco        # CLI session detach
    ast-grep      # AST-aware grep
    delta         # better diff tool
    difftastic    # syntax-aware diff
    diffutils     # classic diff utils
    doggo         # DNS client for humans
    dos2unix      # file conversion
    du-dust       # better du
    duf           # better df
    eza           # modern 'ls' replacement
    fd            # better find
    file          # detect file type by content
    goaccess      # realtime log analyzer
    grc           # generic text colorizer
    inotify-tools # shell inotify bindings
    kmon          # kernel activity monitor
    lnav          # fancy log viewer
    lsof          # list open files
    moreutils     # assorted unix utils (sponge, etc.)
    ncdu          # interactive du
    nnn           # CLI file manager
    parallel      # parallel xargs
    procps        # /proc tools
    progress      # show progress for coreutils
    psmisc        # killall and friends
    pueue         # queue manager
    pv            # pipe viewer
    readline      # readline library
    reptyr        # move app to another pty
    ripgrep       # better grep
    rlwrap        # readline wrapper for everything
    rmlint        # remove duplicates
    stow          # manage farms of symlinks
    tig           # git TUI
    ugrep         # better grep, rg alternative
  ];
}

