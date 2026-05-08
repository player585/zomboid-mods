# 🧟 zomboid-mods

> Project Zomboid mods by **player585**
> Built for Build 41 + Build 42 | Steam Workshop ready

A collection of hand-crafted mods for Project Zomboid. Each mod lives in its own subfolder with full source code, documentation, and Workshop-ready packaging.

---

## 📦 Mod List

| Mod | Description | Status | Build |
|-----|-------------|--------|-------|
| [⚡ Electric Scooter](./electric-scooter) | Near-silent battery-powered scooter. Stealth vehicle, HUD battery indicator, right-click battery check | ✅ v1.0.0 | 41 + 42 |

> More mods coming. Drop a ⭐ to follow along.

---

## 🚀 How to Install a Mod

### Option 1 — Steam Workshop
1. Find the mod on the [Steam Workshop](https://steamcommunity.com/app/108600/workshop/)
2. Click Subscribe
3. Launch PZ → Main Menu → Mods → Enable → Play

### Option 2 — Manual Install
1. Download the mod subfolder (e.g. `electric-scooter/`)
2. Copy the inner mod folder from `Contents/mods/` to:
   - Linux:   `~/Zomboid/Workshop/`
   - Windows: `C:\Users\<You>\Zomboid\Workshop\`
   - Mac:     `~/Zomboid/Workshop/`
3. Launch PZ → Main Menu → Mods → Enable → Play

---

## 🗂️ Repo Structure

```
zomboid-mods/
├── README.md
├── .gitignore
├── .github/
│   ├── CONTRIBUTING.md
│   └── ISSUE_TEMPLATE/
│       ├── bug_report.md
│       └── mod_request.md
├── electric-scooter/
│   ├── README.md
│   ├── workshop.txt
│   └── Contents/mods/ElectricScooter/
│       ├── common/media/lua/shared/
│       ├── common/media/lua/client/
│       ├── common/media/lua/server/
│       ├── common/media/scripts/
│       ├── common/media/textures/   ← ADD PNG TEXTURES HERE
│       ├── common/media/models/     ← ADD FBX MODEL HERE
│       ├── common/media/sound/      ← ADD OGG SOUNDS HERE
│       ├── 42/mod.info
│       └── 41/mod.info
└── [next-mod-name]/
```

---

## ⚙️ Dev Setup

```bash
git clone https://github.com/player585/zomboid-mods.git
```

Symlink or copy the mod folder into `~/Zomboid/Workshop/` for live testing, then commit changes back here.

---

## 🐛 Debug Commands

Add `-debug` to Steam launch options, then in-game:

```
/addvehicle "Base.ElectricScooter" "YourPlayerName"
/additem "Base.Battery"
```

Logs: `~/Zomboid/console.txt`

---

## 📜 Modding Stack

| Tool | Purpose |
|------|---------|
| Lua | Game logic, events, UI, MP sync |
| ZedScript `.txt` | Items, vehicles, recipes, sounds |
| VSCode + Umbrella ext | Syntax highlighting |
| GIMP | Textures (512x512 PNG) |
| Audacity | Sounds (export `.ogg`) |
| TileZed / BuildingEd | Custom maps |
| PZ Java API | https://zomboid-javadoc.com |

---

## 📄 License

MIT — fork it, mod it, ship it.
