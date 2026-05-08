# 🧟 zomboid-mods

> Project Zomboid mods by **player585**
> Built for Build 41 + Build 42 · Steam Workshop ready

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)
[![Lua syntax](https://github.com/player585/zomboid-mods/actions/workflows/lua-lint.yml/badge.svg)](./.github/workflows/lua-lint.yml)
[![PRs welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](./.github/CONTRIBUTING.md)

A collection of hand-crafted mods for Project Zomboid. Each mod lives in its
own subfolder with full source, docs, and Workshop-ready packaging.

---

## 📦 Mods

| Mod | Description | Status | Build |
|-----|-------------|--------|-------|
| [⚡ Electric Scooter](./electric-scooter) | Near-silent battery-powered scooter. Stealth vehicle, HUD battery indicator, right-click battery check | ✅ v1.0.0 (assets pending) | 41 + 42 |

> More mods coming — see [ROADMAP.md](./ROADMAP.md). Drop a ⭐ to follow along.

---

## 🚀 Install a mod

### Steam Workshop
1. Find the mod on the [Steam Workshop](https://steamcommunity.com/app/108600/workshop/)
2. Subscribe
3. Launch PZ → Main Menu → Mods → Enable → Play

### Manual
1. Download the mod subfolder (e.g. `electric-scooter/`)
2. Copy the inner mod folder from `Contents/mods/` to:
   - Linux / Mac: `~/Zomboid/Workshop/`
   - Windows: `C:\Users\<You>\Zomboid\Workshop\`
3. Launch PZ → Main Menu → Mods → Enable → Play

---

## 🗂️ Repo structure

```
zomboid-mods/
├── README.md                    ← you are here
├── LICENSE                      ← MIT
├── CHANGELOG.md
├── ROADMAP.md
├── CODE_OF_CONDUCT.md
├── SECURITY.md
├── .gitignore
├── .editorconfig
├── .github/
│   ├── CONTRIBUTING.md
│   ├── PULL_REQUEST_TEMPLATE.md
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug_report.md
│   │   └── mod_request.md
│   └── workflows/
│       └── lua-lint.yml         ← CI: Lua syntax + ZedScript brace check
├── docs/                        ← PZ modding reference material
│   ├── README.md
│   ├── Project-Zomboid-Modding-Complete-Guide.md
│   └── Project-Zomboid-Deep-Dive.md
├── scripts/
│   └── new-mod.sh               ← scaffolder for a new mod
└── electric-scooter/            ← Mod #1
    ├── README.md
    ├── workshop.txt
    └── Contents/mods/ElectricScooter/
        ├── common/media/lua/{shared,client,server}/
        ├── common/media/scripts/vehicles/
        ├── common/media/{textures,models,sound}/
        ├── 41/mod.info
        └── 42/mod.info
```

---

## ⚙️ Dev setup

```bash
git clone https://github.com/player585/zomboid-mods.git
cd zomboid-mods
```

Symlink (or copy) the mod folder into `~/Zomboid/Workshop/` for live testing,
then commit changes back here.

### Scaffold a new mod in one command

```bash
./scripts/new-mod.sh fishing-overhaul FishingOverhaul "Fishing Overhaul"
```

This creates the full Build 41 + 42 folder layout, `mod.info` files,
`workshop.txt`, a stub README, and a starter Lua core file.

---

## 🐛 Debug commands

Add `-debug` to Steam launch options, then in-game:

```
/addvehicle "Base.ElectricScooter" "YourPlayerName"
/additem    "Base.Battery"
```

Logs: `~/Zomboid/console.txt`

---

## 📜 Modding stack

| Tool | Purpose |
|------|---------|
| Lua | Game logic, events, UI, MP sync |
| ZedScript `.txt` | Items, vehicles, recipes, sounds |
| VSCode + Umbrella ext | Syntax highlighting |
| GIMP | Textures (512 × 512 PNG) |
| Audacity | Sounds (export `.ogg`) |
| TileZed / BuildingEd | Custom maps |
| [PZ Java API](https://zomboid-javadoc.com) | Engine reference |

Reference docs are in [docs/](./docs).

---

## 🤝 Contributing

See [.github/CONTRIBUTING.md](./.github/CONTRIBUTING.md). PRs welcome — every
push runs Lua syntax + ZedScript brace-balance checks via GitHub Actions.

## 📄 License

[MIT](./LICENSE) — fork it, mod it, ship it.
