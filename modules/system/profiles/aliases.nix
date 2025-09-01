##
# Module: system/profiles/aliases
# Purpose: Alias profiles.services.* → servicesProfiles.* for unified naming.
# Key options: none (option redirection only).
# Dependencies: lib.mkAliasOptionModule; affects modules referencing profiles.services.*
{ lib, ... }: {
  # Provide a unified namespace: profiles.services.* is an alias for servicesProfiles.*
  # This keeps existing modules working while allowing consistent usage under profiles.*
  imports = [
    (lib.mkAliasOptionModule [ "profiles" "services" ] [ "servicesProfiles" ])
  ];
}
