# Contributing to zomboid-mods

Maintained by **player585** | Built with **zmodder**

---

## Adding a New Mod

1. Create a subfolder: `your-mod-name/` (lowercase, hyphenated)
2. Add `README.md`, `workshop.txt`, and `Contents/mods/YourModId/`
3. Follow the Build 42 versioned structure:
   - `common/` — shared Lua + scripts for all builds
   - `42/mod.info` — Build 42 metadata
   - `41/mod.info` — Build 41 metadata
4. Update root `README.md` mod table with new row
5. Commit and push:
```bash
git add .
git commit -m "Add [Mod Name] v1.0.0"
git push
```
6. Upload to Steam Workshop: **Main Menu → Workshop → Create and Update Items**
7. Paste the assigned Workshop ID into `workshop.txt` → commit

---

## Mod Status Tags

| Tag | Meaning |
|-----|---------|
| ✅ v1.x.x | Stable, live on Workshop |
| 🚧 WIP | In active development |
| 🧪 Beta | Testing, not on Workshop yet |
| ⚠️ B42 Only | Requires Build 42 unstable branch |

---

## Dev Stack

- **Lua** — game logic, events, UI, multiplayer sync
- **ZedScript `.txt`** — items, recipes, vehicles, sounds
- **VSCode + Umbrella extension** — syntax highlighting
- **GIMP** — textures and icons (512x512 PNG)
- **Audacity** — sounds (export as `.ogg`)
- **TileZed** — map modding (bundled with PZ via Steam Tools)

---

## Debug & Testing

Enable debug mode via Steam launch option: `-debug`
Spawn admin commands in-game:
Logs: `~/.steam/.../Zomboid/console.txt`
