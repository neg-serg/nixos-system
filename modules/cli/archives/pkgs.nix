{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    lbzip2 # parallel bzip2
    p7zip # 7z x
    pzip # parallel zip archiver
    rapidgzip # fast gzip unarchiver
    unrar-wrapper # unrar
    unzip # zip archive operations
    xz # xz archiver
    zip # zip archiver
  ];
}
