# Changelog

All notable changes to this repo are documented here. Format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the project
adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html) on a
**per-mod** basis (each mod's `mod.info` carries its own `modversion=`).

## [Unreleased]

### Changed
- **Repo layout:** all mods now live under a top-level `mods/` folder so
  they’re visually grouped instead of mixing with infra files. Moved
  `electric-scooter/` → `mods/electric-scooter/` via `git mv` (history
  preserved). Updated every doc reference and the scaffolder.

### Added
- Repo-wide AA pass: LICENSE (MIT), CODE_OF_CONDUCT, SECURITY policy, this
  CHANGELOG, `.editorconfig`, GitHub PR template, Lua-syntax CI workflow,
  `scripts/new-mod.sh` scaffolder, `docs/` folder with PZ modding references,
  `ROADMAP.md`.

### Fixed
- **Electric Scooter HUD** — rewrote with `ISUIElement` (the previous version
  called `UIManager.DrawTextureScaled` and `getDebugDrawing()`, neither of
  which exist in retail PZ). Switched draw event from the non-existent
  `OnPreUIDraw` to a proper UI-mounted singleton driven by `OnPlayerUpdate`.
- **Electric Scooter Engine** — replaced `IsoGridSquare:getPlayers()`
  (does not exist) with `IsoPlayer.players` enumeration filtered by distance.
- **Vehicle script** — removed `itemType = null` from the Engine part
  (ZedScript treats `null` as a literal string, breaking part installation).
- **mod.info** — added `authors`, `tags`, `icon`, `require=`; aligned the
  Build 41 / Build 42 descriptions so they don't drift.

---

## Per-mod history

### Electric Scooter

#### [1.0.0] — 2026-05-08
- Initial release. Battery-powered single-seat scooter, near-silent engine
  (loudness 4), HUD battery indicator, right-click "Check Battery", spawns in
  suburbs and parking lots, server-authoritative battery drain.
- **Note:** Assets (textures, FBX model, OGG sounds, posters) not yet
  shipped — see `mods/electric-scooter/README.md` for the asset list.
- **Note:** Not yet published to Steam Workshop; `workshop.txt` still
  has `id=0`.
