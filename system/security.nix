{pkgs, lib, ...}: {
  # Tell p11-kit to load/proxy opensc-pkcs11.so, providing all available slots
  # (PIN1 for authentication/decryption, PIN2 for signing).
  environment.etc."pkcs11/modules/opensc-pkcs11".text = ''
    module: ${pkgs.opensc}/lib/opensc-pkcs11.so
  '';

  security = {
    protectKernelImage = false; # prevent replacing the running kernel image
    lockKernelModules = false;
    polkit = {
        enable = true;
        debug = true;
    };
    tpm2 = {
      enable = true; # enable Trusted Platform Module 2 support
      abrmd.enable = lib.mkDefault false; # enable Trusted Platform 2 userspace resource manager daemon
      # The TCTI is the "Transmission Interface" that is used to communicate with a
      # TPM. this option sets TCTI environment variables to the specified values if enabled
      #  - TPM2TOOLS_TCTI
      #  - TPM2_PKCS11_TCTI
      tctiEnvironment.enable = lib.mkDefault true;
      pkcs11.enable = lib.mkDefault false; # enable TPM2 PKCS#11 tool and shared library in system path
    };
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
    sudo.extraConfig = ''
        Defaults timestamp_timeout = 300 # makes sudo ask for password less often
    '';
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
          {
            command = "${pkgs.util-linux}/bin/dmesg";
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
