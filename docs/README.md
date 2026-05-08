# 📚 docs/

Reference material for Project Zomboid modding, included in the repo so it
travels with the code.

| File | What it is |
|------|------------|
| [Project-Zomboid-Modding-Complete-Guide.md](./Project-Zomboid-Modding-Complete-Guide.md) | End-to-end modding overview: folder structure, ZedScript, Lua events, item & vehicle templates, sounds, recipes, multiplayer rules. |
| [Project-Zomboid-Deep-Dive.md](./Project-Zomboid-Deep-Dive.md) | Long-form deep dive on game internals, AI, render loop, and modding hooks. |

## Useful external links

- **Official PZ Modding Wiki:** <https://pzwiki.net/wiki/Modding>
- **PZ Java API (auto-generated):** <https://zomboid-javadoc.com>
- **The Indie Stone Forums (modding):** <https://theindiestone.com/forums>
- **Steam Workshop (PZ):** <https://steamcommunity.com/app/108600/workshop/>
- **VSCode Umbrella extension:** search the marketplace for "Umbrella" (PZ Lua/ZedScript syntax highlighting)

## When to read what

| You want to … | Read |
|---------------|------|
| Add a new vehicle | Complete Guide → Vehicles section + `mods/electric-scooter/` as a reference implementation |
| Add a new item / recipe | Complete Guide → Items + Recipes |
| Hook a Lua event | Complete Guide → Events list |
| Understand the engine | Deep Dive |
| Set up your dev environment | Root [README.md](../README.md) → Dev Setup |
| Contribute a new mod | [.github/CONTRIBUTING.md](../.github/CONTRIBUTING.md) |
