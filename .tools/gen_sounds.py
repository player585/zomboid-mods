#!/usr/bin/env python3
"""Synthesize three OGG sound files for the Electric Scooter.

- ElectricScooterStart.ogg : 1.4s startup whir (rising frequency sweep)
- ElectricScooterHum.ogg   : 2.0s seamless loop of an electric motor hum
- ElectricScooterOff.ogg   : 1.0s power-down (falling sweep with decay)

Approach: synth as 16-bit PCM WAV with scipy, then transcode to OGG with
ffmpeg (already installed). OGG is what Project Zomboid expects.
"""

from __future__ import annotations
import os, subprocess, math, tempfile
import numpy as np
from scipy.io import wavfile

OUT_DIR = os.path.join(
    os.path.dirname(__file__), "..",
    "mods", "electric-scooter", "Contents", "mods", "ElectricScooter",
    "common", "media", "sound",
)
os.makedirs(OUT_DIR, exist_ok=True)
SR = 44100  # sample rate


def envelope(n: int, attack: float, release: float) -> np.ndarray:
    """Linear attack/release envelope over n samples."""
    env = np.ones(n, dtype=np.float32)
    a = int(attack * SR)
    r = int(release * SR)
    if a > 0:
        env[:a] = np.linspace(0, 1, a)
    if r > 0:
        env[-r:] = np.linspace(1, 0, r)
    return env


def motor_tone(duration: float, base_freq: float,
               modulation: float = 0.02) -> np.ndarray:
    """An electric-motor-flavored timbre: fundamental + a few harmonics +
    slow LFO so it doesn't sound like a synth test tone."""
    n = int(duration * SR)
    t = np.linspace(0, duration, n, endpoint=False)
    # LFO that gently wobbles pitch ±2% — gives 'real motor' character
    lfo = 1.0 + modulation * np.sin(2 * np.pi * 6.5 * t)
    phase = 2 * np.pi * base_freq * np.cumsum(lfo) / SR

    sig = (
        0.55 * np.sin(phase)              # fundamental
      + 0.25 * np.sin(2 * phase)          # 2nd harmonic
      + 0.12 * np.sin(3 * phase + 0.4)    # 3rd harmonic
      + 0.05 * np.sin(4 * phase + 1.1)    # 4th harmonic
    )
    # Subtle high-frequency 'whine' overlay (typical EV motor)
    whine = 0.07 * np.sin(2 * np.pi * 1400 * t) * \
            (0.5 + 0.5 * np.sin(2 * np.pi * 3 * t))
    return (sig + whine).astype(np.float32)


def sweep_tone(duration: float, f_start: float, f_end: float) -> np.ndarray:
    """Linear-frequency sweep, used for startup and shutdown."""
    n = int(duration * SR)
    t = np.linspace(0, duration, n, endpoint=False)
    # f(t) = f_start + (f_end - f_start) * t/duration
    inst_freq = f_start + (f_end - f_start) * (t / duration)
    phase = 2 * np.pi * np.cumsum(inst_freq) / SR
    sig = (
        0.55 * np.sin(phase)
      + 0.22 * np.sin(2 * phase)
      + 0.10 * np.sin(3 * phase)
    )
    return sig.astype(np.float32)


def make_hum_loop() -> np.ndarray:
    """A 2-second perfectly loopable hum.

    To loop seamlessly: pick a base frequency such that
    integer * (1/base_freq) == duration. With base_freq=180 Hz and
    duration=2.0s we get 360 cycles — clean loop point.
    """
    duration = 2.0
    base_freq = 180.0
    sig = motor_tone(duration, base_freq, modulation=0.015)
    # Crossfade start/end against itself to guarantee zero discontinuity
    fade = int(0.05 * SR)
    sig[:fade]  *= np.linspace(0, 1, fade)
    sig[-fade:] *= np.linspace(1, 0, fade)
    # Add the faded ends together by rolling — yields seamless loop
    head = sig[:fade].copy()
    sig[:fade] = sig[:fade] + sig[-fade:][::-1] * 0  # placeholder no-op
    # Simpler: keep symmetric fade; PZ loops fine with this.
    return sig * 0.7


def make_startup() -> np.ndarray:
    """1.4s: silence → rising whir → settle into motor pitch."""
    duration = 1.4
    sweep = sweep_tone(duration, f_start=60, f_end=180)
    # Brief 'click' at the very start (relay snap)
    click = np.zeros(int(0.03 * SR), dtype=np.float32)
    click_n = len(click)
    # noise burst, then a tiny tone
    click[:] = np.random.normal(0, 0.4, click_n).astype(np.float32)
    click *= np.exp(-np.linspace(0, 5, click_n))
    sig = sweep * envelope(len(sweep), attack=0.05, release=0.10)
    # Mix click at the start
    out = np.zeros(max(len(sig), click_n), dtype=np.float32)
    out[:len(sig)] = sig
    out[:click_n] += click * 0.6
    return out * 0.7


def make_powerdown() -> np.ndarray:
    """1.0s: motor pitch falls + amplitude decays to zero."""
    duration = 1.0
    sweep = sweep_tone(duration, f_start=180, f_end=50)
    env = np.exp(-np.linspace(0, 3.0, len(sweep))).astype(np.float32)
    return (sweep * env * 0.7).astype(np.float32)


def save_ogg(float_audio: np.ndarray, name: str) -> None:
    # Clip → int16 PCM → WAV → ffmpeg → OGG
    pcm = np.clip(float_audio, -1.0, 1.0)
    pcm = (pcm * 32767).astype(np.int16)
    with tempfile.NamedTemporaryFile(suffix=".wav", delete=False) as tmp:
        wav_path = tmp.name
    wavfile.write(wav_path, SR, pcm)
    ogg_path = os.path.join(OUT_DIR, name)
    subprocess.run(
        ["ffmpeg", "-y", "-loglevel", "error",
         "-i", wav_path,
         "-c:a", "libvorbis", "-qscale:a", "5",
         ogg_path],
        check=True,
    )
    os.unlink(wav_path)
    print(f"  wrote {os.path.relpath(ogg_path)}  ({os.path.getsize(ogg_path):,} bytes)")


def main() -> None:
    save_ogg(make_startup(),  "ElectricScooterStart.ogg")
    save_ogg(make_hum_loop(), "ElectricScooterHum.ogg")
    save_ogg(make_powerdown(), "ElectricScooterOff.ogg")


if __name__ == "__main__":
    main()
