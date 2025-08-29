{pkgs, ...}: {
  imports = [./tmux ./archives];
  environment.systemPackages = with pkgs; [
    abduco # cli session detach
    ast-grep # ast-aware grep
    delta # better diff tool
    difftastic # syntax-aware diff
    diffutils # classic diff utils
    doggo # dns client for humans
    dos2unix # file convertation
    du-dust # better du
    duf # better df
    eza # more modern version of exa ls replacer
    fd # better find
    file # get filetype from content
    goaccess # realtime log analyzer
    grc # generic text colorizer
    inotify-tools # shell inotify bindings
    kmon # kernel activity monitor
    lnav # fancy log viewer
    lsof # list open something
    moreutils # some fancy unix utils like sponge
    ncdu # interactive du
    nnn # cli filemanager
    parallel # parallel xargs
    procps # info about processes using /proc
    progress # show progress over all coreutils
    psmisc # killall and friends
    pueue # queue manager
    pv # pipe viewer
    readline # readline library
    reptyr # move app to another pty, tmux as an example ( echo 0 > /proc/sys/kernel/yama/ptrace_scope )
    ripgrep # better grep
    rlwrap # readline wrapper for everything
    rmlint # remove duplicates
    stow # manage farms of symlinks
    tig # git viewer
    ugrep # better grep, rg alternative
  ];
}
