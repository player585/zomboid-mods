#!/usr/bin/env python3
"""Generate placeholder vehicle textures for Electric Scooter.

All textures are 512x512 PNG. They are intentionally simple but coherent so
the vehicle renders cleanly in PZ until real art replaces them.

Color choices:
  - Skin:    matte teal (electric vehicle feel, distinct from vanilla cars)
  - Rust:    sparse orange-brown pixel splotches on transparent
  - Mask:    flat magenta in the paintable region, transparent elsewhere
             (PZ multiplies the player-chosen paint color through the mask)
  - Lights:  white/yellow glow regions on transparent (headlight + taillight)
  - Damage1: scattered dark scratches on transparent (light damage overlay)
  - Damage2: heavier dents + missing-panel rectangles (heavy damage overlay)
"""

from __future__ import annotations
import os, math, random
from PIL import Image, ImageDraw, ImageFilter
import numpy as np

OUT_DIR = os.path.join(
    os.path.dirname(__file__), "..",
    "mods", "electric-scooter", "Contents", "mods", "ElectricScooter",
    "common", "media", "textures", "vehicles",
)
os.makedirs(OUT_DIR, exist_ok=True)

SIZE = 512
random.seed(585)
np.random.seed(585)


def save(img: Image.Image, name: str) -> None:
    path = os.path.join(OUT_DIR, name)
    img.save(path, "PNG", optimize=True)
    print(f"  wrote {os.path.relpath(path)}  ({os.path.getsize(path):,} bytes)")


# ----- 1. Skin -----------------------------------------------------------
def make_skin() -> Image.Image:
    # Base matte teal with a faint vertical gradient for "metallic" feel.
    base = np.zeros((SIZE, SIZE, 3), dtype=np.float32)
    top = np.array([28, 110, 122], dtype=np.float32)   # darker teal
    bot = np.array([46, 158, 168], dtype=np.float32)   # lighter teal
    for y in range(SIZE):
        t = y / (SIZE - 1)
        base[y, :] = (1 - t) * top + t * bot

    # Add subtle noise so it doesn't look like a solid color
    noise = np.random.normal(0, 2.5, (SIZE, SIZE, 1)).astype(np.float32)
    base = np.clip(base + noise, 0, 255)

    img = Image.fromarray(base.astype(np.uint8), "RGB").convert("RGBA")

    # UV-style guide rectangles so the vehicle silhouette has some visual
    # structure even before a real skin is dropped in. These are drawn very
    # faintly.
    d = ImageDraw.Draw(img, "RGBA")
    panels = [
        (40, 60, 472, 220, "FRAME"),
        (60, 240, 452, 360, "DECK"),
        (90, 380, 422, 470, "WHEELS"),
    ]
    for x0, y0, x1, y1, label in panels:
        d.rectangle((x0, y0, x1, y1), outline=(255, 255, 255, 35), width=2)
        d.text((x0 + 10, y0 + 8), label, fill=(255, 255, 255, 70))

    return img


# ----- 2. Rust overlay ---------------------------------------------------
def make_rust() -> Image.Image:
    img = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    d = ImageDraw.Draw(img, "RGBA")
    for _ in range(220):
        cx, cy = random.randint(0, SIZE), random.randint(0, SIZE)
        r = random.randint(2, 14)
        alpha = random.randint(80, 200)
        # Orange-brown rust colors
        color = (
            random.randint(120, 180),
            random.randint(50, 90),
            random.randint(20, 50),
            alpha,
        )
        d.ellipse((cx - r, cy - r, cx + r, cy + r), fill=color)
    img = img.filter(ImageFilter.GaussianBlur(radius=1.2))
    return img


# ----- 3. Paint mask -----------------------------------------------------
def make_mask() -> Image.Image:
    # Solid magenta over the "frame" region only — PZ uses the alpha channel
    # to decide what gets repainted. Transparent elsewhere.
    img = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    d = ImageDraw.Draw(img, "RGBA")
    d.rectangle((40, 60, 472, 220), fill=(255, 0, 255, 255))   # frame top
    d.rectangle((60, 240, 452, 360), fill=(255, 0, 255, 255))  # deck
    return img


# ----- 4. Lights ---------------------------------------------------------
def make_lights() -> Image.Image:
    img = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    d = ImageDraw.Draw(img, "RGBA")
    # Headlight (front, top center): warm white
    d.ellipse((220, 70, 292, 142), fill=(255, 240, 200, 255))
    # Taillight (rear, bottom center): red
    d.ellipse((220, 410, 292, 460), fill=(220, 30, 30, 255))
    # Soft glow
    img = img.filter(ImageFilter.GaussianBlur(radius=4))
    # Re-stamp crisp cores over the blur
    d = ImageDraw.Draw(img, "RGBA")
    d.ellipse((236, 86, 276, 126), fill=(255, 255, 240, 255))
    d.ellipse((236, 420, 276, 450), fill=(255, 80, 80, 255))
    return img


# ----- 5. Damage layers --------------------------------------------------
def make_damage(level: int) -> Image.Image:
    img = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    d = ImageDraw.Draw(img, "RGBA")
    count = 40 if level == 1 else 110
    for _ in range(count):
        x, y = random.randint(0, SIZE), random.randint(0, SIZE)
        if level == 1:
            # thin scratches
            x2 = x + random.randint(-30, 30)
            y2 = y + random.randint(-30, 30)
            d.line((x, y, x2, y2), fill=(20, 20, 20, random.randint(110, 200)),
                   width=random.randint(1, 2))
        else:
            # bigger dents
            r = random.randint(6, 22)
            d.ellipse((x - r, y - r, x + r, y + r),
                      fill=(10, 10, 10, random.randint(140, 220)))
    if level == 2:
        # A couple of "missing panel" rectangles
        for _ in range(3):
            x = random.randint(40, SIZE - 120)
            y = random.randint(40, SIZE - 120)
            w = random.randint(40, 90)
            h = random.randint(20, 60)
            d.rectangle((x, y, x + w, y + h), fill=(0, 0, 0, 255))
    return img


def main() -> None:
    print(f"Writing textures to: {OUT_DIR}")
    save(make_skin(),       "ElectricScooter_skin.png")
    save(make_rust(),       "ElectricScooter_rust.png")
    save(make_mask(),       "ElectricScooter_mask.png")
    save(make_lights(),     "ElectricScooter_lights.png")
    save(make_damage(1),    "ElectricScooter_damage1.png")
    save(make_damage(2),    "ElectricScooter_damage2.png")


if __name__ == "__main__":
    main()
