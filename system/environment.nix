{pkgs, ...}: {
  environment.wordlist.enable = true; # to make "look" utility work
  environment.shells = with pkgs; [zsh];
  environment.localBinInPath = true;
  # This is using a rec (recursive) expression to set and access XDG_BIN_HOME within the expression
  # For more on rec expressions see https://nix.dev/tutorials/first-steps/nix-language#recursive-attribute-set-rec
  environment.sessionVariables = {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_DESKTOP_DIR = "$HOME/.local/desktop";
    XDG_DOCUMENTS_DIR = "$HOME/doc/";
    XDG_DOWNLOAD_DIR = "$HOME/dw";
    XDG_MUSIC_DIR = "$HOME/music";
    XDG_PICTURES_DIR = "$HOME/pic";
    XDG_PUBLICSHARE_DIR = "$HOME/1st_level/upload/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    XDG_TEMPLATES_DIR = "$HOME/1st_level/templates";
    XDG_VIDEOS_DIR = "$HOME/vid";
    ZDOTDIR = "$HOME/.config/zsh";
  };

  environment.variables = {
    ASPELL_CONF = ''
      per-conf $XDG_CONFIG_HOME/aspell/aspell.conf;
      personal $XDG_CONFIG_HOME/aspell/en_US.pws;
      repl $XDG_CONFIG_HOME/aspell/en.prepl;
    '';
    HISTFILE = "$XDG_DATA_HOME/bash/history";
    INPUTRC = "$XDG_CONFIG_HOME/readline/inputrc";
    LESSHISTFILE = "$XDG_CACHE_HOME/lesshst";
    WGETRC = "$XDG_CONFIG_HOME/wgetrc";
  };
}
