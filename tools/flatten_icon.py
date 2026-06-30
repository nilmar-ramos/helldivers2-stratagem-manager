"""Strip wiki cyan/dark backgrounds from stratagem PNGs."""
import sys
from pathlib import Path

from PIL import Image


def is_bg(r: int, g: int, b: int) -> bool:
    if r < 35 and g < 45 and b < 50:
        return True
    if abs(r - 85) < 20 and abs(g - 185) < 25 and abs(b - 210) < 25:
        return True
    if abs(r - 78) < 20 and abs(g - 172) < 25 and abs(b - 195) < 25:
        return True
    return False


def flatten(src: Path, dst: Path) -> None:
    im = Image.open(src).convert("RGBA")
    px = im.load()
    w, h = im.size
    for y in range(h):
        for x in range(w):
            r, g, b, a = px[x, y]
            if is_bg(r, g, b):
                px[x, y] = (0, 0, 0, 0)
    dst.parent.mkdir(parents=True, exist_ok=True)
    im.save(dst)


if __name__ == "__main__":
    flatten(Path(sys.argv[1]), Path(sys.argv[2]))
