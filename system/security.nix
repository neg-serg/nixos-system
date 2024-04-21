{pkgs, ...}: {
  # Tell p11-kit to load/proxy opensc-pkcs11.so, providing all available slots
  # (PIN1 for authentication/decryption, PIN2 for signing).
  environment.etc."pkcs11/modules/opensc-pkcs11".text = ''
    module: ${pkgs.opensc}/lib/opensc-pkcs11.so
  '';

  security = {
    pam = {
      loginLimits = [
        {
          domain = "@gamemode";
          item = "nice";
          type = "-";
          value = "-10";
        }
        {
          domain = "@audio";
          item = "rtprio";
          type = "-";
          value = "95";
        }
        {
          domain = "@audio";
          item = "memlock";
          type = "-";
          value = "4194304";
        }
        {
          domain = "neg";
          item = "rtprio";
          type = "-";
          value = "95";
        }
        {
          domain = "neg";
          item = "memlock";
          type = "-";
          value = "4194304";
        }
        {
          domain = "@realtime";
          item = "rtprio";
          type = "-";
          value = "95";
        }
        {
          domain = "@pipewire";
          item = "rtprio";
          type = "-";
          value = "95";
        }
        {
          domain = "@pipewire";
          item = "nice";
          type = "-";
          value = "-19";
        }
        {
          domain = "@pipewire";
          item = "memlock";
          type = "-";
          value = "4194304";
        }
      ];
      services = {
        login.u2fAuth = true;
        sudo.u2fAuth = true;
      };
    };
    polkit.enable = true;
    sudo.extraRules = [
      {
        commands = [
          {
            command = "${pkgs.systemd}/bin/systemctl suspend";
            options = ["NOPASSWD"];
          }
          {
            command = "${pkgs.systemd}/bin/reboot";
            options = ["NOPASSWD"];
          }
          {
            command = "${pkgs.systemd}/bin/poweroff";
            options = ["NOPASSWD"];
          }
        ];
        groups = ["wheel"];
      }
    ];
    sudo.execWheelOnly = true;
    sudo.wheelNeedsPassword = true;
  };
}
