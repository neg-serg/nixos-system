{ pkgs, ... }: {
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
        # Once #292115 is merged and has reached nixos-unstable, you'll be able to use services.pipewire.wireplumber.extraLuaConfig as well:
        # services.pipewire.wireplumber.extraLuaConfig.bluetooth."51-bluez-config" = ''
        # 	bluez_monitor.properties = {
        # 		["bluez5.enable-sbc-xq"] = true,
        # 		["bluez5.enable-msbc"] = true,
        # 		["bluez5.enable-hw-volume"] = true,
        # 		["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
        # 	}
        # '';
        wireplumber.configPackages = [
            # bluetooth support(maybe not needed, check it later)
            (pkgs.writeTextDir "share/wireplumber/bluetooth.lua.d/51-bluez-config.lua" ''
                bluez_monitor.properties = {
                    ["bluez5.enable-sbc-xq"] = true,
                    ["bluez5.enable-msbc"] = true,
                    ["bluez5.enable-hw-volume"] = true,
                    ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
                }
            '')
        ];
    };
}
