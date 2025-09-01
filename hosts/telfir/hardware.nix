{
  lib,
  config,
  ...
}: {
  # Hardware and performance tuning specific to host 'telfir'
  hardware.storage.autoMount.enable = true;
  hardware.video.amd.useMesaGit = true;

  profiles.performance.enable = true;

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
}
