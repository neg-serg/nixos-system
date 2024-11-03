{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    p7zip # 7z x
    unrar-wrapper # unrar
    unzip # zip archive operations
  ];
}
