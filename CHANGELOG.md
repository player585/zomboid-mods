# Changelog

All notable changes to this repo are documented here. Format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the project
adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html) on a
**per-mod** basis (each mod's `mod.info` carries its own `modversion=`).

## [Unreleased]

### Added
- **Electric Scooter placeholder asset kit** — the mod is now ship-runnable
  end-to-end without missing-file errors:
  - 6 textures (skin, rust, mask, lights, damage1, damage2) at 512×512 PNG.
  - `poster.png` (512×512) and `icon.png` (128×128) for both Build 41 and 42.
  - 3 OGG sounds at 44.1 kHz mono: 2.0s seamless hum loop, 1.4s startup
    whir, 1.0s power-down decay.
  - `ElectricScooter.fbx` placeholder mesh (deck + 2 wheels + handlebar
    post + bar, ~40 vertices) as ASCII FBX 7.4.
- `.tools/` folder with Python generators (`gen_textures.py`,
  `gen_poster.py`, `gen_sounds.py`, `gen_fbx.py`) plus `gen_all.sh`
  orchestrator and a `.tools/README.md`. Reproducible: any contributor
  can regen the kit with `pip install Pillow numpy scipy && ./.tools/gen_all.sh`.
- Electric Scooter `mod.info` already pointed at `icon.png` — file is
  now actually present.

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
- **Note:** Placeholder assets ship with v1.0.0 — textures, FBX mesh,
  OGG sounds, posters, and icons. Real art replaces them under the same
  filenames (no code changes needed). See `mods/electric-scooter/README.md`
  and `.tools/README.md`.
- **Note:** Not yet published to Steam Workshop; `workshop.txt` still
  has `id=0`.
