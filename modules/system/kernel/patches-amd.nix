##
# Module: system/kernel/patches-amd
# Purpose: structuredExtraConfig for AMD-oriented kernel settings.
# Key options: none (direct kernel config values).
# Dependencies: Affects boot.kernelPatches.
{lib, ...}: let
  inherit (lib.kernel) yes no freeform;
  inherit (lib.attrsets) mapAttrs;
in {
  boot.kernelPatches = [
    {
      name = "amd-platform-patches";
      patch = null; # no external patch; apply structured config below
      structuredExtraConfig = mapAttrs (_: lib.id) {
        X86_AMD_PSTATE = yes;
        X86_EXTENDED_PLATFORM = no;
        X86_MCE_INTEL = no;
        LRU_GEN = yes;
        LRU_GEN_ENABLED = yes;
        CPU_FREQ_STAT = yes;

        HZ = freeform "1000";
        HZ_250 = no;
        HZ_1000 = yes;

        PREEMPT = yes;
        PREEMPT_BUILD = yes;
        PREEMPT_COUNT = yes;
        PREEMPT_VOLUNTARY = no;
        PREEMPTION = yes;

        TREE_RCU = yes;
        PREEMPT_RCU = yes;
        RCU_EXPERT = yes;
        TREE_SRCU = yes;
        TASKS_RCU_GENERIC = yes;
        TASKS_RCU = yes;
        TASKS_RUDE_RCU = yes;
        TASKS_TRACE_RCU = yes;
        RCU_STALL_COMMON = yes;
        RCU_NEED_SEGCBLIST = yes;
        RCU_FANOUT = freeform "64";
        RCU_FANOUT_LEAF = freeform "16";
        RCU_BOOST = yes;
        RCU_BOOST_DELAY = freeform "500";
        RCU_NOCB_CPU = yes;
        RCU_LAZY = yes;
      };
    }
  ];
}
