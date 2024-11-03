{pkgs, ...}: {
  imports = [./tmux];
  environment.systemPackages = with pkgs; [
    abduco # cli session detach
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
    inotify-tools # shell inotify bindings
    lsof # list open something
    ncdu # interactive du
    nnn # cli filemanager
    parallel # parallel xargs
    procps # info about processes using /proc
    progress # show progress over all coreutils
    psmisc # killall and friends
    pv # pipe viewer
    readline # readline library
    reptyr # move app to another pty, tmux as an example ( echo 0 > /proc/sys/kernel/yama/ptrace_scope )
    ripgrep # better grep
    rlwrap # readline wrapper for everything
    rmlint # remove duplicates
    stow # manage farms of symlinks
    tig # git viewer
  ];
}
