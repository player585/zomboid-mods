# Adding a New Mod to This Repo

Follow this pattern every time zmodder ships a new mod.

## Step 1 — Create the mod subfolder

```
zomboid-mods/
└── your-mod-name/         ← lowercase, hyphenated
    ├── README.md
    ├── workshop.txt
    └── Contents/mods/YourModId/
        ├── common/media/...
        ├── 42/mod.info
        └── 41/mod.info
```

## Step 2 — Update the root README.md mod table

Add a row to the table in `/README.md`:

```markdown
| [🔧 Mod Name](./your-mod-name) | One-line description | ✅ v1.0.0 | 41 + 42 |
```

## Step 3 — Commit and push

```bash
git add .
git commit -m "Add [Mod Name] v1.0.0"
git push origin main
```

## Step 4 — Upload to Steam Workshop

1. Copy mod folder to `C:\Users\<You>\Zomboid\Workshop\`
2. In-game: Main Menu → Workshop → Create and Update Items
3. Paste the assigned Steam Workshop ID back into `workshop.txt`
4. Commit the updated `workshop.txt`

## Mod Status Tags

| Tag | Meaning |
|-----|---------|
| ✅ v1.x.x | Stable, released |
| 🚧 WIP | In development |
| 🧪 Beta | Testing, not on Workshop yet |
| ⚠️ B42 Only | Build 42 unstable branch required |
