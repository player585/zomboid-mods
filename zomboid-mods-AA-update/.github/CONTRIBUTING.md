# Contributing to zomboid-mods

Maintained by **player585** | Built with **zmodder**

---

## 📁 Adding a New Mod

Each mod gets its own subfolder at the repo root.

### Step 1 — Create the folder structure
```
zomboid-mods/
└── your-mod-name/               ← lowercase, hyphenated
    ├── README.md
    ├── workshop.txt
    └── Contents/mods/YourModId/
        ├── common/
        │   └── media/
        │       ├── lua/
        │       │   ├── shared/  ← constants, utilities (both sides)
        │       │   ├── client/  ← UI, input, HUD
        │       │   └── server/  ← spawning, events, persistence
        │       ├── scripts/     ← ZedScript .txt files
        │       ├── textures/    ← .png files
        │       ├── models/      ← .fbx files
        │       └── sound/       ← .ogg files
        ├── 42/mod.info
        └── 41/mod.info
```

### Step 2 — Write `mod.info` for each build
```
name=Your Mod Name
id=YourModId
description=Short description here.
poster=poster.png
url=https://github.com/player585/zomboid-mods
modversion=1.0.0
pzversion=42
```

### Step 3 — Write `workshop.txt`
```
version=1
id=0
title=Your Mod Name
description=Full description for Steam Workshop page.
tags=Build 42;Build 41
visibility=public
```

### Step 4 — Update root README.md mod table
Add a new row:
```markdown
| [🔧 Mod Name](./your-mod-name) | Short description | ✅ v1.0.0 | 41 + 42 |
```

### Step 5 — Commit and push
```bash
cd "/home/fiveightfive/Documents/My docs/Zomboid MODS"
git add .
git commit -m "Add [Mod Name] v1.0.0"
git push
```

### Step 6 — Upload to Steam Workshop
1. Copy mod folder to `~/Zomboid/Workshop/`
2. Launch PZ → **Main Menu → Workshop → Create and Update Items**
3. Fill in title, description, preview image
4. Click **Upload**
5. Copy the assigned Workshop ID back into `workshop.txt`:
   ```
   id=XXXXXXXXXX
   ```
6. Commit: `git commit -am "Add Workshop ID for [Mod Name]" && git push`

---

## 🏷️ Mod Status Tags

| Tag | Meaning |
|-----|---------|
| ✅ v1.x.x | Stable, live on Steam Workshop |
| 🚧 WIP | In active development, not released |
| 🧪 Beta | Playable but not on Workshop yet |
| ⚠️ B42 Only | Requires Build 42 unstable branch |

---

## 🛠️ Dev Stack

| Tool | Use |
|------|-----|
| Lua | Game logic, events, UI, MP sync |
| ZedScript `.txt` | Items, recipes, vehicles, sounds |
| VSCode + Umbrella ext | Syntax highlighting for PZ Lua API |
| GIMP | Textures and icons (512x512 PNG) |
| Audacity | Sound files — export as `.ogg` |
| TileZed / BuildingEd | Map and building modding |
| PZ Java API Docs | https://zomboid-javadoc.com |

---

## 🐛 Debug & Testing

**Enable debug mode:**
Add `-debug` to Steam launch options for Project Zomboid.

**Useful in-game commands:**
```
/addvehicle "Base.ElectricScooter" "YourName"
/additem "Base.Battery"
/additem "Base.Axe"
/teleport "YourName" x y
```

**Log file location:**
- Linux: `~/Zomboid/console.txt`
- Windows: `C:\Users\<You>\Zomboid\console.txt`

**Common Lua errors:**
| Error | Fix |
|-------|-----|
| `attempt to index a nil value` | Object doesn't exist yet — check event timing |
| `no such field` | Typo in ZedScript property name |
| Items not spawning | Distribution not loaded server-side |
| Mod not loading | Check `mod.info` path and B42 folder structure |

---

## 📦 Required Assets per Mod

Every vehicle mod needs these files (NOT included in code — must be sourced):

| File | Format | Size | Where to Get |
|------|--------|------|-------------|
| `*_skin.png` | PNG | 512x512 | GIMP / Photoshop |
| `*_rust.png` | PNG | 512x512 | GIMP |
| `*_mask.png` | PNG | 512x512 | GIMP |
| `*_lights.png` | PNG | 512x512 | GIMP |
| `*.fbx` | FBX | — | Sketchfab (CC0), TurboSquid |
| `*.ogg` | OGG | — | freesound.org → Audacity |
| `poster.png` | PNG | 512x512 | GIMP / Canva |
