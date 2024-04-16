{ pkgs, ... }: {
    security = {
        pam = {
            loginLimits = [
                {domain = "@gamemode"; item = "nice"; type = "-"; value = "-10";}
                {domain = "@audio"; item = "rtprio"; type = "-"; value = "99";}
                {domain = "@audio"; item = "memlock"; type = "-"; value = "8388608";}
                {domain = "@realtime"; item = "rtprio"; type = "-"; value = "99";}
            ];
            services = {
                login.u2fAuth = true;
                sudo.u2fAuth = true;
            };
        };
        polkit.enable = true;
        sudo.extraRules = [{
              commands = [{
                  command = "${pkgs.systemd}/bin/systemctl suspend";
                  options = ["NOPASSWD"];
              }{
                  command = "${pkgs.systemd}/bin/reboot";
                  options = ["NOPASSWD"];
              }{
                  command = "${pkgs.systemd}/bin/poweroff";
                  options = ["NOPASSWD"];
              }];
              groups = ["wheel"];
        }];
        sudo.execWheelOnly = true;
        sudo.wheelNeedsPassword = true;
    };
}
