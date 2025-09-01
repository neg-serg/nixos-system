{lib, ...}:
# Security-focused toggles to harden the system at a small performance cost.
let
  inherit (lib) mkEnableOption;
in {
  options.profiles.security = {
    enable = mkEnableOption "Enable security-oriented kernel tweaks (e.g., page poisoning).";
  };
}
