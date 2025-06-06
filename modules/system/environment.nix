{
  lib,
  pkgs,
  config,
  ...
}: {
  environment = {
    wordlist.enable = true; # to make "look" utility work
    shells = with pkgs; [zsh];
    localBinInPath = true;

    # This is using a rec (recursive) expression to set and access XDG_BIN_HOME within the expression
    # For more on rec expressions see https://nix.dev/tutorials/first-steps/nix-language#recursive-attribute-set-rec
    sessionVariables = {
      NIXOS_OZONE_WL = "1"; # Optional, hint Electron apps to use Wayland:
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

    extraInit = let
      user = "neg"; # Load variables from home-manager
      homedir = config.users.users.${user}.home;
    in ''
      if [ "$(id -un)" = "${user}" ]; then
        . "${homedir}/.local/state/nix/profile/etc/profile.d/hm-session-vars.sh"
      fi
    '';

    variables = let
      makePluginPath = format:
        (lib.makeSearchPath format [
          "/run/current-system/sw/lib"
          "/etc/profiles/per-user/$USER/lib"
          "$HOME/.local/state/nix/profile/lib"
        ])
        + ":$HOME/.${format}";
    in {
      ASPELL_CONF = ''
        per-conf $XDG_CONFIG_HOME/aspell/aspell.conf;
        personal $XDG_CONFIG_HOME/aspell/en_US.pws;
        repl $XDG_CONFIG_HOME/aspell/en.prepl;
      '';
      DSSI_PATH = makePluginPath "dssi";
      GTK_USE_PORTAL = 1;
      HISTFILE = "$XDG_DATA_HOME/bash/history";
      INPUTRC = "$XDG_CONFIG_HOME/readline/inputrc";
      LADSPA_PATH = makePluginPath "ladspa";
      LESSHISTFILE = "$XDG_CACHE_HOME/lesshst";
      LV2_PATH = makePluginPath "lv2";
      LXVST_PATH = makePluginPath "lxvst";
      VST3_PATH = makePluginPath "vst3";
      VST_PATH = makePluginPath "vst";
      WGETRC = "$XDG_CONFIG_HOME/wgetrc";
    };
  };
}
