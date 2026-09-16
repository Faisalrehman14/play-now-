#!/usr/bin/env python3
import os
from PIL import Image

root = os.path.dirname(os.path.abspath(__file__))
project = os.path.join(root, "..")
res = os.path.join(root, "app", "src", "main", "res")
icon = Image.open(os.path.join(root, "original-ui", "ic_launcher.png")).convert("RGBA")

sizes = {
    "mipmap-mdpi": 48,
    "mipmap-hdpi": 72,
    "mipmap-xhdpi": 96,
    "mipmap-xxhdpi": 144,
    "mipmap-xxxhdpi": 192,
}
for folder, size in sizes.items():
    out_dir = os.path.join(res, folder)
    os.makedirs(out_dir, exist_ok=True)
    icon.resize((size, size), Image.LANCZOS).save(os.path.join(out_dir, "ic_launcher.png"))

drawable = os.path.join(res, "drawable")
os.makedirs(drawable, exist_ok=True)
bg = Image.open(os.path.join(project, "images", "background.jpg")).convert("RGB")
bg.save(os.path.join(drawable, "login_bg.jpg"), quality=86)
print("icons and login bg ready")
