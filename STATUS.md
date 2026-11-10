# STATUS

## Done

- Fork of loyalpartner/selfsync is the tidevibe sync server (Rust, Docker, SQLite).
- Agent notes, status, ignore rules, and a Cloud Agent install step are in the repo.

## Next

Milestone 1: run selfsync in Docker on a Debian server, test Edge and Chrome tab and tab-group sync, then build a bare save/restore workspaces extension.

## Decisions

- Companion MV3 extension plus a new workspaces API in this fork.
- Chrome and Edge first.
- A workspace holds windows, tabs, tab groups, and pins. One window per workspace.
- Toolbar popup UI. Keyboard and vim first, with a fuzzy switcher.
- Fully self-hosted behind a reverse proxy. The extension signs in the way Bitwarden signs in to Vaultwarden.
- Multi-user is decided later.
- Free, with tips only.
- Ships as a Docker image plus Linux binaries, AUR, and `cargo install`.
