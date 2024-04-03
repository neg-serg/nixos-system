{ pkgs, ... }: {
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
        wireplumber.configPackages = [
            (pkgs.writeTextDir "share/wireplumber/bluetooth.lua.d/51-bluez-config.lua" ''
                bluez_monitor.properties = {
                    ["bluez5.enable-sbc-xq"] = true,
                    ["bluez5.enable-msbc"] = true,
                    ["bluez5.enable-hw-volume"] = true,
                    ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
                }
                monitor.alsa.rules = [
                  {
                    matches = [
                      {
                        # Matches all sources
                        node.name = "~alsa_input.*"
                      },
                      {
                        # Matches all sinks
                        node.name = "~alsa_output.*"
                      }
                    ]
                    actions = {
                      update-props = {
                        session.suspend-timeout-seconds = 0
                      }
                    }
                  }
                ]
                # bluetooth devices
                monitor.bluez.rules = [
                  {
                    matches = [
                      {
                        # Matches all sources
                        node.name = "~bluez_input.*"
                      },
                      {
                        # Matches all sinks
                        node.name = "~bluez_output.*"
                      }
                    ]
                    actions = {
                      update-props = {
                        session.suspend-timeout-seconds = 0
                      }
                    }
                  }
                ]
            '')
        ];
    };
}
