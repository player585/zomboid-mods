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

### Option 1 — Steam Workshop *(easiest)*
1. Find the mod on the [Steam Workshop](https://steamcommunity.com/app/108600/workshop/)
2. Click **Subscribe**
3. Launch Project Zomboid → **Main Menu → Mods → Enable the mod → Play**

### Option 2 — Manual Install from this Repo
1. Download the mod subfolder (e.g. `electric-scooter/`)
2. Copy the `ElectricScooter` folder (inside `Contents/mods/`) to:
   - **Windows:** `C:\Users\<YourName>\Zomboid\Workshop\`
   - **Linux:** `~/.local/share/Steam/steamapps/common/ProjectZomboid/` *(or)* `~/Zomboid/Workshop/`
   - **Mac:** `~/Zomboid/Workshop/`
3. Launch Project Zomboid → **Main Menu → Mods → Enable the mod → Play**

---

## 🗂️ Repo Structure

```
zomboid-mods/
├── README.md                        ← You are here
├── .github/
│   └── CONTRIBUTING.md              ← Dev workflow & how to add mods
├── electric-scooter/                ← Mod #1
│   ├── README.md                    ← Mod-specific docs & asset guide
│   ├── workshop.txt                 ← Steam Workshop metadata
│   └── Contents/mods/ElectricScooter/
│       ├── common/                  ← Lua + scripts (all builds)
│       │   └── media/
│       │       ├── lua/
│       │       │   ├── shared/      ← ElectricScooter_Core.lua
│       │       │   ├── client/      ← HUD + ContextMenu
│       │       │   └── server/      ← Engine + Distribution
│       │       ├── scripts/vehicles/← vehicle_electricscooter.txt
│       │       ├── textures/        ← [ADD PNG TEXTURES HERE]
│       │       ├── models/          ← [ADD FBX MODEL HERE]
│       │       └── sound/           ← [ADD OGG SOUNDS HERE]
│       ├── 42/mod.info              ← Build 42 metadata
│       └── 41/mod.info              ← Build 41 metadata
└── [next-mod-name]/                 ← Future mods follow same pattern
```

---

## ⚙️ Developer Setup

```bash
git clone https://github.com/player585/zomboid-mods.git
cd zomboid-mods
```

For live testing, symlink or copy your mod folder to:
- **Linux:** `~/Zomboid/Workshop/`
- **Windows:** `C:\Users\<You>\Zomboid\Workshop\`

See [`.github/CONTRIBUTING.md`](./.github/CONTRIBUTING.md) for the full workflow.

---

## 🐛 Debug Commands (in-game)

```
/addvehicle "Base.ElectricScooter" "YourPlayerName"
/additem "Base.Battery"
```

Enable debug mode: Add `-debug` to Steam launch options.
Logs: `~/Zomboid/console.txt`

---

## 📜 Modding Stack

| Tool | Purpose |
|------|---------|
| Lua | Game logic, events, UI, MP sync |
| ZedScript `.txt` | Items, vehicles, recipes, sounds |
| VSCode + Umbrella ext | Syntax highlighting |
| GIMP | Textures & icons (512x512 PNG) |
| Audacity | Sound files (export as `.ogg`) |
| TileZed / BuildingEd | Custom map modding |

---

## 📄 License

MIT — fork it, mod it, ship it. Credit appreciated but not required.
