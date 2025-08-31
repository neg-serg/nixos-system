# Interesting stuff

```
nixtheplanet.url = "github:matthewcroughan/NixThePlanet";
```

```
nixos-generators
```

## Hyprland: Single Source of Truth and Updates

- Source of truth: `inputs.hyprland` is pinned to a stable tag (see `flake.nix`).
- Dependencies are kept in lockstep via `follows`:
  - `hyprland-protocols` → `hyprland/hyprland-protocols`
  - `hyprland-qtutils` → `hyprland/hyprland-qtutils`
  - `hyprland-qt-support` → `hyprland/hyprland-qtutils/hyprland-qt-support`
  - `xdg-desktop-portal-hyprland` → `hyprland/xdph`
- Usage in modules:
  - `programs.hyprland.package = inputs.hyprland.packages.<system>.hyprland`
  - `programs.hyprland.portalPackage = inputs.xdg-desktop-portal-hyprland.packages.<system>.xdg-desktop-portal-hyprland`
  - Do not add `xdg-desktop-portal-hyprland` to `xdg.portal.extraPortals` (to avoid duplicate unit) — it comes via `portalPackage`.

How to update Hyprland (and related deps):

1) Change `inputs.hyprland.url` in `flake.nix` (e.g., to a new release tag).
2) Update the lock: `nix flake lock --update-input hyprland`.
3) Rebuild the system: `nh os switch /etc/nixos`.

Auto‑update (optional): if `system.autoUpgrade` with flakes is enabled, you can add `--update-input hyprland` to automatically pull newer Hyprland. We typically update it manually to keep compatibility under control.
