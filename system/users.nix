{
  lib,
  pkgs,
  config,
  ...
}:
with rec {
  groupExists = grp: builtins.hasAttr grp config.users.groups;
  groupsIfExist = builtins.filter groupExists;
}; {
  users = {
    users.root.hashedPassword = "*"; # lock root account
    users.neg = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPKg+t07fFxKPqtDR3rRpvS6Tc9Rrh5yv7fC5GFrBtyK neg@telfir"
      ];
      hashedPassword = "$6$dy0VIe3yFCwdxh2q$CkgfitafpeqFwYn7fqmR/CRP29G/h9sBcN8sOPSXfgkCeraXA6B8VOoJLrsaktUsSnfHbC0RqDHcnnUCtICF4.";
      description = "Neg";
      extraGroups = groupsIfExist [
        "audio"
        "docker"
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
    users.motd = let
      exec = package: program: "${package}/bin/${program}";
      util = exec pkgs.coreutils;
      uptime = exec pkgs.procps "uptime";
      grep = exec pkgs.gnugrep "grep";
      countUsers = ''${util "who"} -q | ${util "head"} -n1 | ${util "tr"} ' ' \\n | ${util "uniq"} | ${util "wc"} -l'';
      countSessions = ''${util "who"} -q | ${util "head"} -n1 | ${util "wc"} -w'';
    in ''
      (
          # Get the common color codes from lib
          ${toString lib.common.shellColors}
          # Color accent to use in any primary text
          CA=$PURPLE
          CAB=$BPURPLE
          echo
          echo -e " █ ''${BWHITE}Welcome back.''${CO}"
          echo    " █"
          echo -e " █ ''${BWHITE}Hostname......:''${CAB} ${config.networking.hostName}''${CO}"
          echo -e " █ ''${BWHITE}OS Version....:''${CO} NixOS ''${CAB}${config.system.nixos.version}''${CO}"
          echo -e " █ ''${BWHITE}Configuration.:''${CO} ''${CAB}${self.rev or "\${BRED}(✘ )\${CO}\${BWHITE} Dirty"}''${CO}"
          echo -e " █ ''${BWHITE}Uptime........:''${CO} $(${uptime} -p | ${util "cut"} -d ' ' -f2- | GREP_COLORS='mt=01;35' ${grep} --color=always '[0-9]*')"
          echo -e " █ ''${BWHITE}SSH Logins....:''${CO} There are currently ''${CAB}$(${countUsers})''${CO} users logged in on ''${CAB}$(${countSessions})''${CO} sessions"
          echo
      )
    '';
  };
}
