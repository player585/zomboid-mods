# ⚡ Electric Scooter — Project Zomboid Mod

**Version:** 1.0.0 (code complete — assets pending)
**Compatible:** Build 41 + Build 42
**Author:** player585 / zmodder
**Workshop:** _not published yet_ (`workshop.txt` has `id=0`)

---

## Features

- Near-silent electric engine (loudness = 4 vs 70–100 for cars) — barely attracts zombies
- Battery-powered — no gas tank required
- Single seat / lightweight (90 kg vs ~1000 kg for cars)
- Battery HUD indicator (green / yellow / red) shown when riding
- Right-click "Check Battery" context menu on the vehicle
- Spawns naturally in suburbs and parking lots (rare-ish find)
- Multiplayer safe — server is authoritative on battery state

## Stats

| Property        | Electric Scooter | Standard Car |
|-----------------|------------------|--------------|
| Engine Loudness | 4                | 70–100       |
| Max Speed       | 50 km/h          | 80–120 km/h  |
| Mass            | 90 kg            | 800–1500 kg  |
| Fuel Source     | Battery          | Gas          |
| Seats           | 1                | 2–5          |
| Trunk Capacity  | 8                | 20–50        |
| Off-Road Rating | 0.65             | 0.8–1.0      |

## Installation

### Steam Workshop
Subscribe → Mods menu → Enable. (Pending publish.)

### Manual
Copy `Contents/mods/ElectricScooter/` into:
- Linux / Mac: `~/Zomboid/Workshop/`
- Windows: `C:\Users\<You>\Zomboid\Workshop\`

Enable in the in-game Mods menu.

## Required assets (NOT IN REPO YET)

### Textures — `common/media/textures/vehicles/`
- `ElectricScooter_skin.png` — main color/UV
- `ElectricScooter_rust.png` — rust overlay
- `ElectricScooter_mask.png` — paint mask
- `ElectricScooter_lights.png` — headlight/taillight glow
- `ElectricScooter_damage1.png` — light damage
- `ElectricScooter_damage2.png` — heavy damage

512 × 512 PNG. Reference any vanilla vehicle in `ProjectZomboid/media/textures/vehicles/`.

### 3D model — `common/media/models/vehicles/`
- `ElectricScooter.fbx` (Y-up). Sketchfab CC0 is the easy path. Scale factor in script is `0.012`.

### Sound — `common/media/sound/`
- `ElectricScooterHum.ogg` — looping motor hum
- `ElectricScooterStart.ogg` — startup whir
- `ElectricScooterOff.ogg` — power-down

OGG at any sample rate. Use [freesound.org](https://freesound.org) → Audacity export.

### Workshop poster — `42/poster.png` and `41/poster.png`
512 × 512 PNG.

## File structure

```
electric-scooter/
├── README.md
├── workshop.txt
└── Contents/mods/ElectricScooter/
    ├── 41/mod.info
    ├── 42/mod.info
    └── common/media/
        ├── lua/
        │   ├── shared/ElectricScooter_Core.lua
        │   ├── client/ElectricScooter_HUD.lua
        │   ├── client/ElectricScooter_ContextMenu.lua
        │   └── server/
        │       ├── ElectricScooter_Engine.lua
        │       └── Items/ElectricScooter_Distribution.lua
        ├── scripts/vehicles/vehicle_electricscooter.txt
        ├── textures/vehicles/    ← TODO: add PNG textures
        ├── models/vehicles/      ← TODO: add FBX model
        └── sound/                ← TODO: add OGG sounds
```

## Spawn (debug / admin)

Add `-debug` to Steam launch options. In-game:

```
/addvehicle "Base.ElectricScooter" "YourPlayerName"
/additem    "Base.Battery"
```

## Tweaking

`common/media/lua/shared/ElectricScooter_Core.lua`:

```lua
ElectricScooter.BATTERY_DRAIN_RATE = 0.0002  -- lower = slower drain
ElectricScooter.MIN_BATTERY_TO_RUN = 5       -- % at which engine cuts off
```

## Test checklist

- [ ] Spawns via `/addvehicle`
- [ ] Engine starts with a battery installed
- [ ] HUD bar appears when riding
- [ ] Right-click → "Check Battery" prints correct charge band
- [ ] Battery condition decreases while engine is running
- [ ] Engine cuts off at ≤ 5% battery
- [ ] Re-loads cleanly in a saved game
- [ ] Works on a dedicated MP server (battery state stays in sync)

## Credits

Code: zmodder / player585 · MIT licensed.
