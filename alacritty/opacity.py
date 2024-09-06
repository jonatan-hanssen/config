#!/usr/bin/env python3
import os, sys
from pathlib import Path

path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "opacity.toml")

with open(path, "r+") as file:
    data = file.read()
    old_opacity = data.split()[-1]
    new_opacity = float(old_opacity) + float(sys.argv[1])

    if new_opacity > 1:
        new_opacity = 1
    if new_opacity < 0:
        new_opacity = 0

    new_data = data.replace(old_opacity, f"{new_opacity:.2f}")
    file.seek(0, 0)
    file.write(new_data)

Path(os.path.join(os.path.dirname(os.path.abspath(__file__)), "alacritty.toml")).touch()
