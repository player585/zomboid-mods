# Electric Scooter — Project Zomboid Mod
**Version:** 1.0.0  
**Compatible:** Build 41 + Build 42  
**Author:** zmodder  

---

## Features
- Near-silent electric engine (loudness = 4, vs cars at 70–100) — barely attracts zombies
- Battery-powered — no gas tank required
- Single seat / lightweight (90kg vs ~1000kg for cars)
- Battery HUD indicator (green/yellow/red) shown when riding
- Right-click "Check Battery" context menu on the vehicle
- Spawns naturally in suburbs, parking lots (rare-ish find)
- Multiplayer safe — server authoritative on battery state

## Stats
| Property         | Electric Scooter | Standard Car   |
|------------------|-----------------|----------------|
| Engine Loudness  | 4               | 70–100         |
| Max Speed        | 50 km/h         | 80–120 km/h    |
| Mass             | 90              | 800–1500       |
| Fuel Source      | Battery         | Gas            |
| Seats            | 1               | 2–5            |
| Trunk Capacity   | 8               | 20–50          |
| Off-Road Rating  | 0.65            | 0.8–1.0        |

## Installation (Manual)
1. Copy the `ElectricScooter` folder into:
   - Windows: `C:\Users\<You>\Zomboid\Workshop\`
2. Enable in the Mods menu in-game

## Installation (Steam Workshop)
Subscribe on Steam Workshop. Enable in Mods menu.

## Required Assets (NOT INCLUDED — create or source these)
The following asset files need to be created and placed in the correct directories:

### Textures (`common/media/textures/vehicles/`)
- `ElectricScooter_skin.png` — Main color/UV texture
- `ElectricScooter_rust.png` — Rust/damage overlay
- `ElectricScooter_mask.png` — Color mask (for paint variations)
- `ElectricScooter_lights.png` — Headlight/taillight glow texture
- `ElectricScooter_damage1.png` — Light damage overlay
- `ElectricScooter_damage2.png` — Heavy damage overlay

Recommended size: 512x512 or 1024x1024 PNG.  
Reference any vanilla vehicle in `ProjectZomboid/media/textures/vehicles/` for format.

### 3D Model (`common/media/models/vehicles/`)
- `ElectricScooter.fbx` — 3D model of the scooter

Tips:
- Free scooter models: Sketchfab (CC0 license), TurboSquid
- Must be FBX format, Y-up orientation
- Scale factor in script is 0.012 — adjust if model appears too large/small
- Reference vanilla vehicle FBX files for bone/pivot structure

### Sound Files (`common/media/sound/`)
- `ElectricScooterHum.ogg` — Looping electric motor hum
- `ElectricScooterStart.ogg` — Startup click/whir
- `ElectricScooterOff.ogg` — Power-down sound

Free sources:
- https://freesound.org — search "electric motor hum", "electric scooter"
- Must be converted to OGG format (Audacity can do this)

### Workshop Poster (`42/poster.png` and `41/poster.png`)
- 512x512 PNG preview image shown in the in-game mod menu
- Create in GIMP, Photoshop, or Canva

---

## File Structure
```
ElectricScooterMod/
├── workshop.txt
├── README.md
└── Contents/mods/ElectricScooter/
    ├── common/
    │   └── media/
    │       ├── scripts/vehicles/vehicle_electricscooter.txt
    │       ├── textures/vehicles/          [ADD TEXTURES HERE]
    │       ├── models/vehicles/            [ADD MODEL HERE]
    │       ├── sound/                      [ADD SOUNDS HERE]
    │       └── lua/
    │           ├── shared/ElectricScooter_Core.lua
    │           ├── client/ElectricScooter_HUD.lua
    │           ├── client/ElectricScooter_ContextMenu.lua
    │           └── server/
    │               ├── ElectricScooter_Engine.lua
    │               └── Items/ElectricScooter_Distribution.lua
    ├── 42/mod.info
    └── 41/mod.info
```

## Spawn Command (Debug / Admin)
```
/addvehicle "Base.ElectricScooter" "YourPlayerName"
```

## Tweaking Battery Drain
Open `ElectricScooter_Core.lua` and adjust:
```lua
ElectricScooter.BATTERY_DRAIN_RATE = 0.0002   -- lower = slower drain
ElectricScooter.MIN_BATTERY_TO_RUN = 5         -- % at which engine dies
```

## Credits
Code: zmodder
