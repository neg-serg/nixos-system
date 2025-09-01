{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    age
    opensc
    p11-kit
    pcsctools
    sops
    ssh-to-age
  ];
}

