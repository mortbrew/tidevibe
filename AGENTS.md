# AGENTS.md

Guidance for agents working in **tidevibe**, a fork of [loyalpartner/selfsync](https://github.com/loyalpartner/selfsync): a self-hosted Chrome / Edge sync server (Rust).

## Build and test

Toolchain pin: `rust-toolchain.toml` (`1.92.0`). System packages the build needs: `protobuf-compiler`, `libprotobuf-dev` (protoc). Docker image is Alpine and installs `musl-dev` and `protobuf-dev`.

```bash
cargo build                  # workspace debug build
cargo build --release        # release, both crates
cargo build --release -p selfsync-server
cargo check
cargo fmt --check
cargo clippy --all-targets -- -D warnings
cargo test                   # full suite (CI)
cargo test -p selfsync-server <filter>
cargo test -p selfsync-nigori <filter>
```

Docker (from `Dockerfile` and `docker-compose.yml`):

```bash
docker build -t tidevibe .
docker compose up --build
```

CI (`.github/workflows/ci.yml`, on `dev` and `main`): `rust:slim` container, install protobuf, then `cargo fmt --check`, `cargo clippy -- -D warnings`, `cargo test`.

Run only the tests that cover what you changed. Afterward report a short pass/fail summary (command, result). Do not paste logs.

## Layout

```
crates/nigori/          # selfsync-nigori: AES-128-CBC + HMAC-SHA256, PBKDF2/Scrypt
crates/sync-server/     # selfsync-server: axum + sea-orm + SQLite
  proto/                # Chromium .proto sources
  build.rs              # prost-build
  src/handler/          # COMMIT, GET_UPDATES, per-browser init
  src/db/               # entities and sea-orm-migration files
  src/admin/            # admin page (askama)
docs/                   # protocol notes
Dockerfile              # multi-stage release build of selfsync-server
docker-compose.yml
```

Identity is `(email, browser_kind)`. Chromium and Edge are separate user rows. Sync listens on `SELFSYNC_ADDR` (default `127.0.0.1:8080`); admin on `SELFSYNC_ADMIN_ADDR` (default `127.0.0.1:8081`). Database path is `SELFSYNC_DB` (default `selfsync.db`).

## Coding conventions

- `cargo fmt` and `cargo clippy --all-targets -- -D warnings` must stay clean.
- Append new files under `crates/sync-server/src/db/migrator/`. Do not edit a migration that has already shipped. SQLite cannot `ALTER TABLE DROP CONSTRAINT`; rebuild the table with raw SQL when a column UNIQUE must go.
- Protobuf responses must set `error_code` to `SUCCESS`. `NigoriSpecifics.encrypt_everything` stays `false`. `store_birthday` is the literal `ProductionEnvironmentDefinition`.
- Edge init uses an empty implicit-passphrase Nigori and five permanent bookmark folders (including `workspace_bookmarks`). Chromium uses a server-built keystore Nigori and four folders.
- Keep generated prost wrappers in `proto.rs` allowed for clippy, dead code, and deprecation.

## Project rules

- Git work stays on `dev`. Do not push to `main` or merge into it. At most one open pull request, and only `dev` → `main`, left unmerged until a person merges it. Never force-push.
- No drive-by refactors. Change only what the task needs.
- Run tests relevant to the files you touched, then a short pass/fail line.
