_: {
  # Balance hardware interrupts across CPU cores to reduce spikes on a single core
  # Helpful on high-core CPUs with heavy GPU/NVMe/Network IRQ load (gaming/desktop)
  services.irqbalance.enable = true;
}

