_: let
  myUser = "neg";
  myHome = "/home/${myUser}";
in {
  systemd.services.mpd.serviceConfig = {
    Environment = "XDG_RUNTIME_DIR=/run/user/1000";
  };

  services.mpd = {
    enable = true;
    user = myUser;
    group = myUser;

    startWhenNeeded = false; # важно
    dataDir = "${myHome}/.config/mpd";
    musicDirectory = "${myHome}/music";
    network = {
      listenAddress = "any";
      port = 6600;
    };

    extraConfig = ''
      log_file "/dev/null"
      max_output_buffer_size "131072"
      max_connections "100"
      connection_timeout "864000"
      restore_paused "yes"
      save_absolute_paths_in_playlists "yes"
      follow_inside_symlinks "yes"
      replaygain "off"
      auto_update "yes"
      mixer_type "hardware"

      audio_output {
        type "alsa"
        name "PipeWire"
        device "default"
        auto_resample "no"
        auto_format "no"
        auto_channels "no"
        replay_gain_handler "none"
        dsd_native "yes"
        dop "no"
        tags "yes"
      }

      audio_output {
        type "alsa"
        name "RME ADI-2/4 PRO SE"
        device "hw:CARD=SE53011083"
        auto_resample "no"
        auto_format "no"
        auto_channels "no"
        replay_gain_handler "none"
        dsd_native "yes"
        dop "no"
        tags "yes"
      }
    '';
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [6600];
  };
}
