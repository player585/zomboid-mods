# 🧟 zomboid-mods

> Project Zomboid mods by **carswell585**  
> Built for Build 41 + Build 42 | Steam Workshop ready

A collection of hand-crafted mods for Project Zomboid. Each mod lives in its own subfolder with full source code, documentation, and Workshop-ready packaging.

---

## 📦 Mod List

| Mod | Description | Status | Build |
|-----|-------------|--------|-------|
| [⚡ Electric Scooter](./electric-scooter) | Near-silent battery-powered scooter. Stealth vehicle, HUD battery indicator, right-click battery check | ✅ v1.0.0 | 41 + 42 |

> More mods coming. Drop a ⭐ to follow along.

---

## 🗂️ Repo Structure

```
zomboid-mods/
├── README.md                  ← You are here
├── electric-scooter/          ← Mod #1
│   ├── README.md
│   ├── workshop.txt
│   └── Contents/mods/ElectricScooter/
│       ├── common/media/...
│       ├── 42/mod.info
│       └── 41/mod.info
└── [future-mod-name]/         ← Next mod goes here
```

---

## 🚀 How to Install Any Mod (Manual)

1. Download the mod folder
2. Copy it to `C:\Users\<You>\Zomboid\Workshop\`
3. Launch Project Zomboid → **Mods** → Enable it → Play

## 🛠️ How to Install (Steam Workshop)

Each mod that has been published will have a Workshop link in its own README.

---

## ⚙️ Dev Setup

Clone the repo:
```bash
git clone https://github.com/player585/zomboid-mods.git
cd zomboid-mods
```

Place your working mod folder directly in `C:\Users\<You>\Zomboid\Workshop\` for live testing, then commit changes back here.

---

## 📜 Modding Stack

- **Language:** Lua (game logic) + ZedScript `.txt` (items/vehicles/recipes)  
- **Tools:** VSCode + Umbrella extension, GIMP, TileZed, Audacity  
- **Targets:** Build 41 (stable) + Build 42 (unstable/beta)  
- **Workshop:** Published under Steam account carswell585

---

## 📄 License

MIT — fork it, mod it, ship it. Credit appreciated but not required.
# zomboid-mods
