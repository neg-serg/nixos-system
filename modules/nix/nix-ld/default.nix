{pkgs, ...}: {
  # run unpatched linux binaries with nix-ld
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      openssl
      curl
      glib
      util-linux
      glibc
      icu
      libunwind
      libuuid
      zlib
      libsecret
      freetype
      libglvnd
      libnotify
      SDL2
      vulkan-loader
      gdk-pixbuf
      xorg.libX11
    ];
  };
}
