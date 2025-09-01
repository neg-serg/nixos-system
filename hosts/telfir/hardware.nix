{
  lib,
  pkgs,
  ...
}: {
  # Hardware and performance tuning specific to host 'telfir'
  hardware.storage.autoMount.enable = true;
  hardware.video.amd.useMesaGit = true;

  # Performance profile comes from the workstation role

  # Host-specific kernel parameters
  boot.kernelParams = [
    "acpi_osi=!"
    "acpi_osi=Linux"
    "video=3840x2160@240"
    # CPU isolation for gaming/low-latency (adjust to your topology)
    "nohz_full=14,15,30,31"
    "rcu_nocbs=14,15,30,31"
    "isolcpus=managed,domain,14-15,30-31"
    "irqaffinity=0-13,16-29"
  ];

  # Avoid double compression
  profiles.performance.zswap.enable = lib.mkForce false;
  zramSwap.enable = lib.mkForce false;

  # Keep services on housekeeping CPUs by default
  systemd.settings.Manager.CPUAffinity = ["0-13" "16-29"];
  # Ban isolated CPUs from IRQ balancing (Zen3 mask example)
  systemd.services.irqbalance.environment.IRQBALANCE_BANNED_CPUS = "0xC000C000";

  # Rename NICs to stable names specific to this host
  services.udev.extraRules = ''
    KERNEL=="eth*", ATTR{address}=="fc:34:97:b7:16:0e", NAME="net0"
    KERNEL=="eth*", ATTR{address}=="fc:34:97:b7:16:0f", NAME="net1"
  '';

  # Host-specific hardware tools
  environment.systemPackages = with pkgs; [
    bazecor # Dygma keyboard configurator
  ];
}
