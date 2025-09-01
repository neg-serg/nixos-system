{pkgs, ...}: {
  environment.systemPackages = with pkgs; [wakapi];
}
