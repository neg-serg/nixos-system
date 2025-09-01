{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    droidcam # Linux client for DroidCam app
  ];
}
