{ lib, config, ... }:
# This module defines a feature flag and granular toggles to apply
# performance-oriented kernel/boot tweaks system-wide.
#
# WARNING: These options may reduce security and/or stability.
# Enable only what you need and understand.
let
  inherit (lib) mkEnableOption mkOption types;
  cfg = config.profiles.performance;
in {
  options.profiles.performance = {
    enable = mkEnableOption (
      "Performance-oriented kernel/boot tweaks (reduces security; use with care)."
    );

    # Granular toggles (all default to true to preserve legacy behavior when
    # profiles.performance.enable = true)
    disableMitigations = mkOption {
      type = types.bool;
      default = true;
      description = "Add mitigations=off (disables CPU vulnerability mitigations).";
    };
    quietBoot = mkOption {
      type = types.bool;
      default = true;
      description = "Reduce boot verbosity (quiet, splash, hide systemd status).";
    };
    disableWatchdogs = mkOption {
      type = types.bool;
      default = true;
      description = "Disable watchdogs (nowatchdog, kernel.nmi_watchdog=0).";
    };
    lowLatencyScheduling = mkOption {
      type = types.bool;
      default = true;
      description = "Favor latency: preempt=full and threadirqs.";
    };
    fastRCU = mkOption {
      type = types.bool;
      default = true;
      description = "Faster RCU grace periods: rcupdate.rcu_expedited=1.";
    };
    pciePerformance = mkOption {
      type = types.bool;
      default = true;
      description = "Prefer PCIe performance: pcie_aspm=performance.";
    };
    trustTSC = mkOption {
      type = types.bool;
      default = true;
      description = "Trust TSC clocksource: tsc=reliable.";
    };
    skipCryptoSelftests = mkOption {
      type = types.bool;
      default = true;
      description = "Skip crypto self-tests: cryptomgr.notests (faster boot).";
    };
    disableAudit = mkOption {
      type = types.bool;
      default = true;
      description = "Disable audit subsystem: audit=0 (lower syscall overhead).";
    };
    noreplaceSmp = mkOption {
      type = types.bool;
      default = true;
      description = "Do not replace SMP alternatives at runtime: noreplace-smp.";
    };
    idleNoMwait = mkOption {
      type = types.bool;
      default = true;
      description = "Avoid MWAIT C-states: idle=nomwait (lower latency).";
    };
    disableUsbAutosuspend = mkOption {
      type = types.bool;
      default = true;
      description = "Disable USB autosuspend: usbcore.autosuspend=-1.";
    };
    disableSplitLockDetect = mkOption {
      type = types.bool;
      default = true;
      description = "Disable split lock detection: split_lock_detect=off.";
    };
  };
}
