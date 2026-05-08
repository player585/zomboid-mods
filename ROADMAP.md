# 🗺️ Roadmap

Living plan of what's shipped, what's next, and what's a maybe.

## Shipped

| Mod | Version | Workshop | Build |
|-----|---------|----------|-------|
| ⚡ Electric Scooter | 1.0.0 (code) — assets pending | not yet | 41 + 42 |

## Active development

_(none right now — pick the next from the queue below)_

## Queue — high priority

| Mod | Sketch | Why it fits |
|-----|--------|-------------|
| 🎣 Fishing Overhaul | New fish items, tide-based spawn rates (NOAA-style tables), rod customization, weighted catch tables by location and time | Plays into delta-fishing IRL background; reuses tide-data muscle |
| 💰 Crypto Barter System | KXC in-game currency, player-to-player trading UI, server-side ledger, anti-dupe rules | Crypto/blockchain wheelhouse, MP-friendly |

## Queue — medium priority

| Mod | Sketch |
|-----|--------|
| 🍄 Mushroom Cultivation | B42 crafting chain: spore prints → substrate → grow tubs → harvest → cook |
| 📻 Radio Broadcast System | Server-side "survivor radio" cycle: scripted broadcasts on intervals, player-submittable broadcast queue |

## Queue — low priority / advanced

| Mod | Sketch |
|-----|--------|
| 🗺️ Delta Survival Map | Custom waterway/delta region built in TileZed |
| 📡 LoRa-Mesh Radio (cross-game) | Hooks PZ in-game radio events to a real Meshtastic node via a sidecar process |

## Cross-cutting infra ideas

- [ ] Add a `tools/check-mod.sh` that validates a mod folder against the
      schema (mod.info present, workshop.txt present, no `null` literals
      in ZedScript, references in scripts match files on disk).
- [ ] Auto-generate `Mod List` in root README from `mod.info` files.
- [ ] GitHub Action that auto-bumps `modversion=` on tagged releases.

---

Pull requests welcome. See [.github/CONTRIBUTING.md](./.github/CONTRIBUTING.md).
