{ lib, ... }: {
  # Provide a unified namespace: profiles.services.* is an alias for servicesProfiles.*
  # This keeps existing modules working while allowing consistent usage under profiles.*
  imports = [
    (lib.mkAliasOptionModule [ "profiles" "services" ] [ "servicesProfiles" ])
  ];
}

