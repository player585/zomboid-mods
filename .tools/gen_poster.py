#!/usr/bin/env python3
"""Generate poster.png + icon.png for both build folders.

Poster is shown by the in-game mod browser and on Steam Workshop.
Icon is the small thumbnail next to the mod in the mod list.
"""

from __future__ import annotations
import os, math
from PIL import Image, ImageDraw, ImageFont, ImageFilter

MOD_ROOT = os.path.join(
    os.path.dirname(__file__), "..",
    "mods", "electric-scooter", "Contents", "mods", "ElectricScooter",
)

TEAL_DARK  = (16, 56, 70)
TEAL_MID   = (34, 120, 138)
TEAL_LIGHT = (90, 200, 215)
ACCENT     = (250, 220, 60)   # warm yellow lightning bolt
INK        = (235, 245, 245)


def load_font(size: int) -> ImageFont.FreeTypeFont:
    candidates = [
        "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
        "/usr/share/fonts/truetype/liberation/LiberationSans-Bold.ttf",
    ]
    for c in candidates:
        if os.path.exists(c):
            return ImageFont.truetype(c, size)
    return ImageFont.load_default()


def gradient_bg(size: int) -> Image.Image:
    img = Image.new("RGB", (size, size), TEAL_DARK)
    px = img.load()
    for y in range(size):
        t = y / (size - 1)
        r = int((1 - t) * TEAL_DARK[0] + t * TEAL_MID[0])
        g = int((1 - t) * TEAL_DARK[1] + t * TEAL_MID[1])
        b = int((1 - t) * TEAL_DARK[2] + t * TEAL_MID[2])
        for x in range(size):
            px[x, y] = (r, g, b)
    return img


def draw_scooter_silhouette(d: ImageDraw.ImageDraw, cx: int, cy: int, scale: float) -> None:
    """Crude top-down scooter silhouette: two wheels, deck, handlebar post, bars."""
    s = scale
    body = INK

    # Rear wheel
    d.ellipse((cx - 110*s, cy + 30*s, cx - 60*s, cy + 80*s), fill=body)
    # Front wheel
    d.ellipse((cx + 60*s, cy + 30*s, cx + 110*s, cy + 80*s), fill=body)
    # Deck (the standing platform)
    d.rounded_rectangle(
        (cx - 90*s, cy + 40*s, cx + 90*s, cy + 65*s),
        radius=int(8*s), fill=body,
    )
    # Handlebar post
    d.rectangle((cx + 75*s, cy - 60*s, cx + 90*s, cy + 50*s), fill=body)
    # Handlebars
    d.rounded_rectangle(
        (cx + 50*s, cy - 70*s, cx + 115*s, cy - 50*s),
        radius=int(6*s), fill=body,
    )
    # Headlight glow
    d.ellipse((cx + 95*s, cy - 80*s, cx + 125*s, cy - 50*s),
              fill=(255, 240, 200))


def draw_lightning(d: ImageDraw.ImageDraw, cx: int, cy: int, scale: float) -> None:
    """A stylized lightning bolt — the 'electric' visual cue."""
    s = scale
    pts = [
        (cx + 0*s,   cy - 110*s),
        (cx - 30*s,  cy - 25*s),
        (cx + 5*s,   cy - 25*s),
        (cx - 20*s,  cy + 80*s),
        (cx + 25*s,  cy - 5*s),
        (cx - 10*s,  cy - 5*s),
        (cx + 20*s,  cy - 110*s),
    ]
    d.polygon(pts, fill=ACCENT)


def make_poster(size: int, build_label: str) -> Image.Image:
    img = gradient_bg(size).convert("RGBA")

    # Soft top-left glow
    glow = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    gd = ImageDraw.Draw(glow)
    gd.ellipse((-200, -200, 320, 320), fill=(*TEAL_LIGHT, 90))
    glow = glow.filter(ImageFilter.GaussianBlur(radius=60))
    img = Image.alpha_composite(img, glow)

    d = ImageDraw.Draw(img, "RGBA")
    cx, cy = size // 2, int(size * 0.50)

    # Scale silhouette to image
    scoot_scale = size / 512
    draw_scooter_silhouette(d, cx, cy + int(20*scoot_scale), scoot_scale)
    draw_lightning(d, cx - int(140*scoot_scale), cy - int(30*scoot_scale), scoot_scale)

    # Title
    title_font = load_font(int(size * 0.10))
    sub_font   = load_font(int(size * 0.045))
    tag_font   = load_font(int(size * 0.035))

    title = "ELECTRIC"
    title2 = "SCOOTER"
    # Centered
    def center_text(text, font, y, fill):
        bbox = d.textbbox((0, 0), text, font=font)
        w = bbox[2] - bbox[0]
        d.text(((size - w) / 2, y), text, font=font, fill=fill)

    center_text(title,  title_font, int(size * 0.06), INK)
    center_text(title2, title_font, int(size * 0.18), INK)
    center_text("near-silent · stealth vehicle",
                sub_font, int(size * 0.82), (210, 230, 230))
    center_text(build_label,
                tag_font, int(size * 0.90), ACCENT)
    center_text("player585 / zmodder",
                tag_font, int(size * 0.945), (180, 200, 205))

    return img.convert("RGB")


def save(img: Image.Image, path: str) -> None:
    img.save(path, "PNG", optimize=True)
    print(f"  wrote {os.path.relpath(path)}  ({os.path.getsize(path):,} bytes)")


def main() -> None:
    for build, label in (("42", "Build 42"), ("41", "Build 41")):
        build_dir = os.path.join(MOD_ROOT, build)
        os.makedirs(build_dir, exist_ok=True)
        save(make_poster(512, label), os.path.join(build_dir, "poster.png"))
        save(make_poster(128, label).resize((128, 128), Image.LANCZOS),
             os.path.join(build_dir, "icon.png"))


if __name__ == "__main__":
    main()
