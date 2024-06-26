{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    age # pgp alternative
    opensc # libraries and utilities to access smart cards
    p11-kit # loading and sharing PKCS#11 modules
    pcsctools # tools used to test a PC/SC driver, card or reader
    sops # secret management
  ];
}
