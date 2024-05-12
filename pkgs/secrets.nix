{pkgs, ...}: {
  nixpkgs.overlays = [
    (
      final: prev: {
        pcsclite = prev.pcsclite.overrideAttrs (old: {
          postPatch = ''
            substituteInPlace src/libredirect.c src/spy/libpcscspy.c \
              --replace-fail "libpcsclite_real.so.1" "$lib/lib/libpcsclite_real.so.1"
          '';
        });
      }
    )
  ];
  environment.systemPackages = with pkgs; [
    opensc # libraries and utilities to access smart cards
    p11-kit # loading and sharing PKCS#11 modules
    pcsctools # tools used to test a PC/SC driver, card or reader

    sops # secret management
    age # pgp alternative
  ];
}
