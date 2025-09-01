{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    overskride # bluetooth and obex client
  ];
}

