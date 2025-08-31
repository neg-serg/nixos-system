{ lib, config, ... }:
# Host-specific kernel parameters for telfir.
# Keep host overrides here to avoid leaking hardware-tuned flags
# into other hosts (e.g. acpi_osi quirks and monitor modes).
let
  isHost = (config.networking.hostName or "") == "telfir";
in
lib.mkIf isHost {
  # Enable performance profile on this host
  profiles.performance.enable = true;

  # Host-specific kernel parameters
  boot.kernelParams = [
    # ACPI OSI quirks: pretend to be "Linux" while disabling generic OSI
    # Helps some BIOS/firmware expose correct methods on certain laptops/desktops
    "acpi_osi=!"
    "acpi_osi=Linux"
    # Force preferred mode for this monitor (4K 240Hz). Adjust per hardware.
    "video=3840x2160@240"
  ];
}
