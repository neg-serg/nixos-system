##
# Module: system/net/ssh
# Purpose: OpenSSH client basics (agent, PKCS#11).
# Key options: none.
# Dependencies: pkgs.openssh, pkgs.opensc.
{pkgs, ...}: {
  programs = {
    ssh = {
      package = pkgs.openssh;
      startAgent = false;
      # agentPKCS11Whitelist = "/nix/store/*";
      # or specific URL if you're paranoid
      # but beware this can break if you don't have exactly matching opensc versions
      # between your main config and home-manager channel
      agentPKCS11Whitelist = "${pkgs.opensc}/lib/opensc-pkcs11.so";
    };
  };
}
