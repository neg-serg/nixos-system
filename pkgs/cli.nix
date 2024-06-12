{
  pkgs,
  stable,
  master,
  ...
}: {
  environment.systemPackages = with pkgs; [
    abduco # cli session detach
    delta # better diff tool
    difftastic # syntax-aware diff
    diffutils # classic diff utils
    master.fd # better find
    file # get filetype from content
    inotify-tools # shell inotify bindings
    lsof # list open something
    parallel # parallel xargs
    procps # info about processes using /proc
    master.progress # show progress over all coreutils
    psmisc # killall and friends
    pv # pipe viewer
    readline # readline library
    master.reptyr # move app to another pty, tmux as an example ( echo 0 > /proc/sys/kernel/yama/ptrace_scope )
    master.ripgrep # better grep
    rlwrap # readline wrapper for everything
    master.eza # more modern version of exa ls replacer
    stable.tig # git viewer
    master.tmux # better screen
  ];
}
