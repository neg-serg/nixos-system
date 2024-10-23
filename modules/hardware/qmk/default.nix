{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    vial # gui configuration for qmk-based keyboards
  ];
}
