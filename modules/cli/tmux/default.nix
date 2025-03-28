{pkgs, ...}: {
  programs.tmux = {
    enable = true; # better screen
    keyMode = "vi";
    clock24 = true;
    plugins = with pkgs.tmuxPlugins; [
      better-mouse-mode # better mouse support for tmux
      fuzzback # search with fzf prefix + / (fzf search backwards)
      # resurrect # restore tmux environment after system restart
    ];
    shortcut = "s";
    secureSocket = false; # survive user logout
    terminal = "tmux-256color";
    historyLimit = 8191;
    extraConfigBeforePlugins = ''
      setw -gq utf8 on

      unbind-key -T copy-mode C-s
      unbind-key -T copy-mode y
      unbind -T prefix C-s
      unbind C-s
      unbind [
      unbind b
      unbind B

      # --[ Plugin settings ]
      # tmux-ressurect
      set -g @resurrect-dir '~/.config/tmux/resurrect/'
      set -g @resurrect-capture-pane-contents 'on'
      set -g @resurrect-save 'S'
      set -g @yank_selection 'primary' # or 'secondary' or 'clipboard'

      # tmux-fuzzback
      set -g @fuzzback-bind '/'
      set -g @fuzzback-popup 0
      set -g @fuzzback-popup-size '80%'

      # keys settings
      set -s extended-keys on
      set -as terminal-features 'xterm*:extkeys'
      set -g xterm-keys on
      set -g set-clipboard on
      set -g allow-passthrough on
    '';
    extraConfig = ''
      set -g update-environment "DISPLAY SSH_ASKPASS SSH_AUTH_SOCK SSH_AGENT_PID SSH_CONNECTION WINDOWID XAUTHORITY"
      set-window-option -g mode-keys vi
      set -wg mode-style "bg=#000008","fg=#367bbf",bold
      # set -g default-shell $\{SHELL\}
      # set -g default-command $\{SHELL\}

      set -sg escape-time 0 # fixes insert mode exit lag in vim
      bind C-a send-prefix # send the prefix to client inside window (ala nested sessions)
      set-window-option -g aggressive-resize on
      bind C-s last-window
      set -g history-limit 8191
      set -s focus-events on
      set -g renumber-windows on

      # 24-bit color support
      set-option -ga terminal-overrides ",tmux*:Tc"
      set-option -ga terminal-overrides ",alacritty*:Tc"
      set-option -ga terminal-overrides ",kitty*:Tc"
      set-option -ga terminal-overrides ",xterm*:Tc"
      set -ga terminal-overrides ",$\{TERM\}:Tc"
      set -as terminal-overrides ",$\{TERM\}:RGB"

      set -ag terminal-overrides ",xterm-256color:RGB" # Enable 24 bit true colors
      # Enable undercurl colors
      set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours
      set -as terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[2 q'
      set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm' # Enable undercurl
      set -as terminal-overrides ',xterm*:sitm=\E[3m' # Italics support
      # Strikethrough support https://github.com/tmux/tmux/issues/612#issuecomment-288408841
      set -as terminal-overrides ',xterm*:smxx=\E[9m'
      set -ga terminal-features '*:clipboard:strikethrough:usstyle:RGB'

      set -g bell-action any # listen for activity on all windows
      set -g base-index 1 # start window indexing at one instead of zero
      set -g pane-border-style fg=blue,bg=default # border colours
      set -g set-titles off # wm window title string (uses statusbar variables)
      set -g automatic-rename on # automatic rename for tmux buffers
      set -g automatic-rename-format '#{b:pane_current_path}'
      set-option -g visual-activity on
      set -g status-keys emacs
      set -g message-style fg=white,bg=black

      set-option -g -q mouse off

      bind -T copy-mode-vi 'C-v' send -X rectangle-toggle
      bind -T copy-mode-vi 'V' send -X select-line
      bind -T copy-mode-vi 'r' send -X rectangle-toggle
      bind -T copy-mode-vi 'Escape' send -X cancel
      bind -T copy-mode-vi 'C-c' send -X cancel

      bind -n M-n new-window
      bind Tab copy-mode

      # ctrl+left/right cycles thru windows
      bind -n C-right next
      bind -n C-left prev

      bind a choose-session
      bind * command-prompt -p 'save window pane to filename:' -I '~/tmux.history' 'capture-pane -S -32768 ; save-buffer %1 ; delete-buffer'

      bind | split-window -h
      bind _ split-window -v
      bind R source-file ~/.config/tmux/tmux.conf \; display-message "tmux.conf reloaded"

      bind b choose-buffer -O name {run "tmux save-buffer -b '%%' - | xsel -i -b"} \; send-keys up
      bind-key -T copy-mode-vi C-c send-keys -X copy-pipe "xsel -i -b" \; send-keys -X cancel
      bind-key -T copy-mode-vi C-Enter send-keys -X copy-pipe "xsel -i -b" \; send-keys -X cancel

      bind -r h resize-pane -L 1
      bind -r j resize-pane -D 1
      bind -r k resize-pane -U 1
      bind -r l resize-pane -R 1

      # Smart pane switching with awareness of Vim splits. - Thanks CHRIS TOOMEY!
      # See: https://github.com/christoomey/vim-tmux-navigator
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
      bind -n M-C-w if "! $is_vim" "kill-pane"

      set -g status on
      set -g status-interval 60
      set -g status-left ""
      set -g status-justify left # center align window list
      set-option -g status-position bottom
      set-option -g status-style fg=white,bg=default,default
      set -g window-status-format "#[bg=#040408]#[fg=#303030] #I#F #[fg=colour232]❯> #[fg=#242424]#W  #[bg=default]"
      set -g window-status-current-format "#[bg=#080812] #I#{?window_flags,#F, } #[fg=colour24]❯> #[fg=default]#W  #[bg=default]"
      set-option -qg status-style "fg=#899CA1"
      set-window-option -qg window-status-style "fg=#617287"
      set-window-option -qg window-status-activity-style "fg=#ff5858"
      set-window-option -qg window-status-bell-style "fg=#ff00ff"
      set -g status-right-length 150
      set-option -g status-right '#[fg=white]#(~/.config/tmux/bin/tmux_statusline)'
      # vim:ft=tmux tw=0
    '';
  };
}
