{master, ...}: {
  programs = {
    ssh = {
      package = master.openssh;
      startAgent = true;
      # agentPKCS11Whitelist = "/nix/store/*";
      # or specific URL if you're paranoid
      # but beware this can break if you don't have exactly matching opensc versions
      # between your main config and home-manager channel
      agentPKCS11Whitelist = "${master.opensc}/lib/opensc-pkcs11.so";
    };
  };
}
