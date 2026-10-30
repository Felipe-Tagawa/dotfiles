#!/usr/bin/env python3
"""
Rofi Wallpaper Gallery Helper
Generates fast thumbnail cache and displays a visual grid in Rofi.
Outputs the chosen wallpaper full path to stdout.
"""

import os
import sys
import glob
import subprocess
from PIL import Image

WALLPAPERS_DIR = os.path.expanduser("~/Pictures/Wallpapers")
if not os.path.isdir(WALLPAPERS_DIR):
    WALLPAPERS_DIR = os.path.expanduser("~/dotfiles/Wallpaper/Pictures/Wallpapers")

CACHE_DIR = os.path.expanduser("~/.cache/wallpaper-thumbs")
os.makedirs(CACHE_DIR, exist_ok=True)

ROFI_THEME = os.path.expanduser("~/.config/rofi/wallpaper-gallery.rasi")

CUSTOM_TITLES = {
    "tsushima-golden-forest.jpg": "Ghost of Tsushima • Golden Forest",
    "tsushima-pampas-moon.jpg": "Ghost of Tsushima • Pampas Moon",
    "colossus-forbidden-lands.png": "Shadow of the Colossus • Forbidden Lands",
    "colossus-fog-horizon.jpg": "Shadow of the Colossus • Fog Horizon",
    "elden-ring-erdtree-vista.jpg": "Elden Ring • Erdtree Vista",
    "elden-ring-landscape.webp": "Elden Ring • Landscape",
    "sekiro-ashina-peaks.jpg": "Sekiro • Ashina Peaks",
    "sekiro-guardian-ape.png": "Sekiro • Guardian Ape",
    "hollow-knight-city-of-tears.jpg": "Hollow Knight • City of Tears",
    "silksong-pharloom-citadel.png": "Silksong • Pharloom Citadel",
    "expedition-33-battlefield-moon.jpg": "Expedition 33 • Battlefield Moon",
    "expedition-33-celestial-ruins.png": "Expedition 33 • Celestial Ruins",
    "destiny-traveler-over-earth.jpg": "Destiny • The Traveler",
    "monster-hunter-ancient-forest.png": "Monster Hunter • Ancient Forest",
    "terraria-floating-island.png": "Terraria • Floating Island",
    "tokyo-rainy-night-street.jpg": "Persona Style • Tokyo Rain",
    "vagabond-mountain-ink.jpg": "Vagabond • Mountain Ink",
    "vagabond-the-strongest.jpeg": "Vagabond • The Strongest",
    "vagabond-art.webp": "Vagabond • Musashi Art",
    "vagabond-dark.webp": "Vagabond • Dark Ink",
    "vinland-thorfinn-black-5k.jpg": "Vinland Saga • Thorfinn",
    "horse.jpg": "Horse • Majestic (Original)",
    "artorias.png": "Dark Souls • Knight Artorias",
    "lady_maria.png": "Bloodborne • Lady Maria",
    "theClimber.png": "The Climber • Kokou no Hito",
    "sephiroth.png": "Final Fantasy VII • Sephiroth",
    "ff13.jpg": "Final Fantasy XIII",
    "farol.png": "Farol • Solitary Lighthouse",
    "torii-gate-dark.jpg": "Dark Shinto Torii",
    "samurai-warrior.png": "Samurai Warrior • Ink Art"
}

def format_title(filename):
    if filename in CUSTOM_TITLES:
        return CUSTOM_TITLES[filename]
    base = os.path.splitext(filename)[0]
    return base.replace("-", " ").replace("_", " ").title()

def get_thumbnail(img_path):
    fname = os.path.basename(img_path)
    thumb_path = os.path.join(CACHE_DIR, f"{fname}.png")
    
    # Gera miniatura se não existir ou se imagem foi modificada
    if not os.path.exists(thumb_path) or os.path.getmtime(img_path) > os.path.getmtime(thumb_path):
        try:
            with Image.open(img_path) as img:
                # Converte para RGB se necessário (para transparência de PNG/WebP)
                if img.mode in ("RGBA", "LA") or (img.mode == "P" and "transparency" in img.info):
                    bg = Image.new("RGB", img.size, (20, 20, 25))
                    bg.paste(img, mask=img.convert("RGBA").split()[3])
                    img = bg
                elif img.mode != "RGB":
                    img = img.convert("RGB")
                
                img.thumbnail((320, 180), Image.Resampling.BICUBIC)
                img.save(thumb_path, "PNG", compress_level=1)
        except Exception:
            return img_path
            
    return thumb_path

def main():
    extensions = ("*.jpg", "*.jpeg", "*.png", "*.webp")
    all_files = []
    for ext in extensions:
        all_files.extend(glob.glob(os.path.join(WALLPAPERS_DIR, ext)))

    if not all_files:
        sys.exit(1)

    # Ordena mantendo os recomendados no topo
    all_files = sorted(set(all_files))
    
    entries = []
    lookup = {}

    for fpath in all_files:
        fname = os.path.basename(fpath)
        # Ignora arquivos temporários ou lixo
        if fname.startswith(".") or fname.startswith("Benchmark"):
            continue
        title = format_title(fname)
        thumb = get_thumbnail(fpath)
        lookup[title] = fpath
        entries.append(f"{title}\0icon\x1f{thumb}\n")

    rofi_input = "".join(entries).encode("utf-8")

    cmd = [
        "rofi",
        "-dmenu",
        "-i",
        "-show-icons",
        "-p", "🖼️  Galeria de Paisagens",
        "-theme", ROFI_THEME
    ]

    try:
        proc = subprocess.Popen(cmd, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL)
        out, _ = proc.communicate(input=rofi_input)
        chosen_title = out.decode("utf-8").strip()

        if chosen_title and chosen_title in lookup:
            print(lookup[chosen_title])
            sys.exit(0)
    except Exception:
        sys.exit(1)

    sys.exit(0)

if __name__ == "__main__":
    main()
