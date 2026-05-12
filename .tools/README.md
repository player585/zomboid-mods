# .tools/

Repo-internal scripts. These are NOT shipped with any mod — they generate
placeholder assets for the Electric Scooter so the mod has working files
to ship until real art lands.

## Regenerate every placeholder

```bash
pip install Pillow numpy scipy
./.tools/gen_all.sh
```

(Needs `ffmpeg` in `$PATH` for the OGG step — it's already on most Linux
distros and installable via `brew install ffmpeg` on macOS.)

## What each script does

| Script | Output |
|---|---|
| `gen_textures.py` | 6 vehicle textures (`skin`, `rust`, `mask`, `lights`, `damage1`, `damage2`) → `mods/electric-scooter/.../textures/vehicles/` |
| `gen_poster.py` | `poster.png` + `icon.png` for both `41/` and `42/` |
| `gen_sounds.py` | 3 OGG sounds (hum loop, startup, power-down) → `.../sound/` |
| `gen_fbx.py` | ASCII FBX placeholder mesh (deck + 2 wheels + handlebar) → `.../models/vehicles/ElectricScooter.fbx` |
| `gen_all.sh` | Runs all four in order |

## Replacing the placeholders with real art

When real assets show up, just drop them in the same filenames. The
generator scripts can stay in `.tools/` — they're handy when you start a
new mod and want a placeholder kit again. Or delete `.tools/` entirely;
nothing in the mod references it.
