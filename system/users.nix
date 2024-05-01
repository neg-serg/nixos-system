{pkgs, ...}: {
  users = {
    users.neg = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPKg+t07fFxKPqtDR3rRpvS6Tc9Rrh5yv7fC5GFrBtyK neg@telfir"
      ];
      hashedPassword = "$6$dy0VIe3yFCwdxh2q$CkgfitafpeqFwYn7fqmR/CRP29G/h9sBcN8sOPSXfgkCeraXA6B8VOoJLrsaktUsSnfHbC0RqDHcnnUCtICF4.";
      description = "Neg";
      extraGroups = [
        "audio"
        "i2c"
        "input"
        "neg"
        "networkmanager"
        "openrazer"
        "systemd-journal"
        "video"
        "wheel"
      ];
    };
    defaultUserShell = pkgs.zsh;
    groups.neg.gid = 1000;
  };
}
