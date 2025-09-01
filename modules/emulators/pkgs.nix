{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    dosbox # DOS emulator
    dosbox-staging # dosbox-staging
    dosbox-x # dosbox-x
  ];
}
