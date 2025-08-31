{ lib, config, ... }:
let
  isHost = (config.networking.hostName or "") == "telfir";
in
lib.mkIf isHost {
  # Host-specific kernel parameters
  boot.kernelParams = [
    "acpi_osi=!"
    "acpi_osi=Linux"
    "video=3840x2160@240"
  ];
}

