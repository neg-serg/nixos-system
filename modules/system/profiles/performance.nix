{ lib, config, ... }:
# This module defines a simple feature flag to toggle
# performance-oriented kernel/boot tweaks system-wide.
#
# WARNING: Enabling this may reduce security and stability
# (e.g. disables CPU mitigations, relaxes watchdogs, etc.).
let
  cfg = config.profiles.performance;
in {
  options.profiles.performance.enable = lib.mkEnableOption (
    "Performance-oriented kernel/boot tweaks (reduces security; use with care)."
  );
}
