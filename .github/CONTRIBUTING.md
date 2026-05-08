# Contributing to zomboid-mods

Maintained by **player585** | Built with **zmodder**

---

## Adding a New Mod

### Step 1 — Folder structure

```
your-mod-name/
├── README.md
├── workshop.txt
└── Contents/mods/YourModId/
    ├── common/media/lua/shared/
    ├── common/media/lua/client/
    ├── common/media/lua/server/
    ├── common/media/scripts/
    ├── common/media/textures/
    ├── common/media/models/
    ├── common/media/sound/
    ├── 42/mod.info
    └── 41/mod.info
```

### Step 2 — `mod.info` template

```
name=Your Mod Name
id=YourModId
description=Short description.
poster=poster.png
url=https://github.com/player585/zomboid-mods
modversion=1.0.0
pzversion=42
```

### Step 3 — `workshop.txt` template

```
version=1
id=0
title=Your Mod Name
description=Full Steam Workshop description.
tags=Build 42;Build 41
visibility=public
```

### Step 4 — Update root `README.md` mod table

```
| [Mod Name](./your-mod-name) | Description | v1.0.0 | 41 + 42 |
```

### Step 5 — Commit and push

```bash
git add .
git commit -m "Add [Mod Name] v1.0.0"
git push
```

### Step 6 — Publish to Steam Workshop

1. Copy mod to `~/Zomboid/Workshop/`
2. PZ → Main Menu → Workshop → Create and Update Items
3. Upload → copy Workshop ID → paste into `workshop.txt` → push

---

## Mod Status Tags

| Tag | Meaning |
|-----|---------|
| ✅ v1.x.x | Stable, live on Workshop |
| 🚧 WIP | In development |
| 🧪 Beta | Testing, not on Workshop |
| ⚠️ B42 Only | Requires Build 42 |

---

## Dev Stack

| Tool | Use |
|------|-----|
| Lua | Game logic, events, UI, MP sync |
| ZedScript `.txt` | Items, recipes, vehicles, sounds |
| VSCode + Umbrella | Syntax highlighting |
| GIMP | Textures (512x512 PNG) |
| Audacity | Sounds (export as `.ogg`) |
| TileZed | Map modding |
| PZ Java API | https://zomboid-javadoc.com |

---

## Debug and Testing

Add `-debug` to Steam launch options. In-game commands:

```
/addvehicle "Base.ElectricScooter" "YourName"
/additem "Base.Battery"
```

Logs: `~/Zomboid/console.txt`

| Error | Fix |
|-------|-----|
| `attempt to index a nil value` | Object does not exist yet — check event timing |
| `no such field` | Typo in ZedScript property |
| Items not spawning | Distribution not loaded server-side |
| Mod not loading | Check `mod.info` path and B42 folder structure |

---

## Required Assets Per Mod

| File | Format | Size | Source |
|------|--------|------|--------|
| `_skin.png` | PNG | 512x512 | GIMP |
| `_rust.png` | PNG | 512x512 | GIMP |
| `_mask.png` | PNG | 512x512 | GIMP |
| `_lights.png` | PNG | 512x512 | GIMP |
| `.fbx` | FBX | any | Sketchfab CC0 |
| `.ogg` | OGG | any | freesound.org |
| `poster.png` | PNG | 512x512 | GIMP / Canva |
