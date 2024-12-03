{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    droidcam # linux client for droidcam app
  ];
}
