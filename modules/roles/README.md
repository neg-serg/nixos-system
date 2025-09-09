# Roles: quick reference

- Enable a role in your host config:
  - `roles.workstation.enable = true;` — desktop defaults (performance profile, SSH, Avahi, Syncthing).
  - `roles.homelab.enable = true;` — self‑hosting defaults (security profile, DNS, SSH, Syncthing, MPD, Navidrome, Wakapi, Nextcloud).
  - `roles.media.enable = true;` — media servers (Jellyfin, Navidrome, MPD, Avahi, SSH).

- Override per‑service toggles via `profiles.services.<name>.enable` (alias: `servicesProfiles.<name>.enable`).
  - Example: `profiles.services.jellyfin.enable = false;`

- Typical next steps per role:
  - Workstation: adjust games stack in `profiles.games.*` and `modules/user/games`.
  - Homelab: set DNS rewrites under `servicesProfiles.adguardhome.rewrites`, define Syncthing devices/folders in `hosts/<host>/services.nix`.
  - Media: set media paths/ports for MPD/Navidrome; Jellyfin ports are opened by the module when enabled.

- Docs: see aggregated options under flake output `packages.${system}."options-md"` when available.

