#!/usr/bin/env python3
"""Download stratagem icons from helldivers.wiki.gg and patch HelldiversData.ahk."""

import re
import time
import urllib.error
import urllib.request
from io import BytesIO
from pathlib import Path

try:
    import fitz  # PyMuPDF
except ImportError:
    raise SystemExit("Run: pip install pymupdf")

ROOT = Path(__file__).resolve().parents[1]
DATA_FILE = ROOT / "HelldiversData.ahk"
ICONS_DIR = ROOT / "icons"
SIZE = 32
DELAY = 0.35
UA = "HelldiversStratagemTool/1.0 (personal project; icon cache)"

# Manual fixes where heuristic fails
ICON_OVERRIDES = {
    "Orbital Illumination Flare": "Orbital_Illumination_Flare_Stratagem_Icon_Background.svg",
    "Hive Breaker Drill": "Hive_Breaker_Drill_Stratagem_Icon_Background.svg",
    "Prospecting Drill": "Prospecting_Drill_Stratagem_Icon_Background.svg",
    "Tectonic Drill": "Tectonic_Drill_Stratagem_Icon_Background.svg",
    "SSSD Delivery": "SSSD_Delivery_Stratagem_Icon_Background.svg",
    "Dark Fluid Vessel": "Dark_Fluid_Vessel_Stratagem_Icon_Background.svg",
    "NUX-223 Hellbomb": "Hellbomb_Stratagem_Icon_Background.svg",
    "B-100 Portable Hellbomb": "Portable_Hellbomb_Stratagem_Icon_Background.svg",
    "B/MD C4 Pack": "C4_Pack_Stratagem_Icon_Background.svg",
    "B/FLAM-80 Cremator": "Cremator_Stratagem_Icon_Background.svg",
    "CQC-1 One True Flag": "One_True_Flag_Stratagem_Icon_Background.svg",
    "StA-X3 W.A.S.P. Launcher": "W.A.S.P._Launcher_Stratagem_Icon_Background.svg",
    "E/GL-21 Grenadier Battlement": "Grenadier_Battlement_Stratagem_Icon_Background.svg",
    "E/MG-101 HMG Emplacement": "HMG_Emplacement_Stratagem_Icon_Background.svg",
    "E/AT-12 Anti-Tank Emplacement": "Anti-Tank_Emplacement_Stratagem_Icon_Background.svg",
    "FX-12 Shield Generator Relay": "Shield_Generator_Relay_Stratagem_Icon_Background.svg",
    "AX/AR-23 Guard Dog": "Guard_Dog_Stratagem_Icon_Background.svg",
    "AX/LAS-5 Rover": "Rover_Stratagem_Icon_Background.svg",
    "AX/FLAM-75 Hot Dog": "Hot_Dog_Stratagem_Icon_Background.svg",
    "AX/ARC-3 K-9": "K-9_Stratagem_Icon_Background.svg",
    "AX/TX-13 Dog Breath": "Dog_Breath_Stratagem_Icon_Background.svg",
    "B-1 Supply Pack": "Supply_Pack_Stratagem_Icon_Background.svg",
    "M-103 Supply FRV": "Supply_FRV_Stratagem_Icon_Background.svg",
    "M-104 Incinerator FRV": "Incinerator_FRV_Stratagem_Icon_Background.svg",
    "TD-220 Bastion MK XVI": "Bastion_MK_XVI_Stratagem_Icon_Background.svg",
    "M-102 Fast Recon Vehicle": "Fast_Recon_Vehicle_Stratagem_Icon_Background.svg",
}

CATEGORY_FALLBACK = {
    "Suprimentos": "Supply_Pack_Stratagem_Icon_Background.svg",
    "Missão": "Reinforce_Stratagem_Icon_Background.svg",
    "Defensivas": "Machine_Gun_Sentry_Stratagem_Icon_Background.svg",
    "Ofensivas": "Orbital_Precision_Strike_Stratagem_Icon.svg",
    "Hangar": "Eagle_Strafing_Run_Stratagem_Icon_Background.svg",
    "Ponte": "Shield_Generator_Relay_Stratagem_Icon_Background.svg",
    "Engenharia": "Anti-Personnel_Minefield_Stratagem_Icon_Background.svg",
    "Oficina": "Patriot_Exosuit_Stratagem_Icon_Background.svg",
}


def slug(name: str) -> str:
    return re.sub(r"[^\w.-]+", "_", name).strip("_")


def candidates(name_en: str):
    if name_en in ICON_OVERRIDES:
        yield ICON_OVERRIDES[name_en]
    base = name_en.replace("/", "-")
    yield f"{base.replace(' ', '_')}_Stratagem_Icon.svg"
    tokens = name_en.split()
    for i in range(1, min(4, len(tokens))):
        rest = " ".join(tokens[i:])
        rs = rest.replace(" ", "_")
        yield f"{rs}_Stratagem_Icon.svg"
        yield f"{rs}_Stratagem_Icon_Background.svg"
    if "/" in name_en:
        after = name_en.split("/", 1)[1].strip()
        ar = after.replace(" ", "_")
        yield f"{ar}_Stratagem_Icon.svg"
        yield f"{ar}_Stratagem_Icon_Background.svg"


def head_exists(filename: str) -> bool:
    url = f"https://helldivers.wiki.gg/images/{filename}"
    req = urllib.request.Request(url, method="HEAD", headers={"User-Agent": UA})
    try:
        with urllib.request.urlopen(req, timeout=20) as resp:
            return resp.status == 200
    except urllib.error.HTTPError:
        return False
    finally:
        time.sleep(DELAY)


def download_svg(filename: str) -> bytes:
    url = f"https://helldivers.wiki.gg/images/{filename}"
    req = urllib.request.Request(url, headers={"User-Agent": UA})
    with urllib.request.urlopen(req, timeout=30) as resp:
        return resp.read()


def svg_to_png(svg_bytes: bytes, out_path: Path):
    doc = fitz.open(stream=svg_bytes, filetype="svg")
    page = doc[0]
    scale = SIZE / max(page.rect.width, page.rect.height, 1)
    pix = page.get_pixmap(matrix=fitz.Matrix(scale, scale), alpha=True)
    pix.save(str(out_path))


def resolve_svg(name_en: str, category: str) -> str:
    for cand in candidates(name_en):
        if head_exists(cand):
            return cand
    fb = CATEGORY_FALLBACK.get(category, "Reinforce_Stratagem_Icon_Background.svg")
    if head_exists(fb):
        return fb
    return "Orbital_Precision_Strike_Stratagem_Icon.svg"


def parse_entries(text: str):
    pattern = re.compile(
        r'"([^"]+)",\s*Map\(\s*'
        r'"Category",\s*"([^"]+)",\s*'
        r'"Code",\s*"([^"]+)",\s*'
        r'"CodeDisplay",\s*"([^"]+)",\s*'
        r'"Description",\s*"([^"]+)",\s*'
        r'"NameEn",\s*"([^"]+)",\s*'
        r'"DescriptionEn",\s*"([^"]+)"',
        re.MULTILINE,
    )
    return pattern.findall(text)


def make_default_icon(path: Path):
    """Simple gray stratagem placeholder."""
    doc = fitz.open()
    page = doc.new_page(width=SIZE, height=SIZE)
    page.draw_rect(fitz.Rect(2, 2, SIZE - 2, SIZE - 2), color=(0.5, 0.5, 0.5), width=1)
    page.insert_text((8, 20), "?", fontsize=14, color=(0.3, 0.3, 0.3))
    pix = page.get_pixmap(alpha=True)
    pix.save(str(path))
    doc.close()


def main():
    ICONS_DIR.mkdir(exist_ok=True)
    text = DATA_FILE.read_text(encoding="utf-8")
    entries = parse_entries(text)

    svg_cache: dict[str, str] = {}
    png_by_svg: dict[str, str] = {}

    for name, category, code, _disp, _desc, name_en, _desc_en in entries:
        if name_en not in svg_cache:
            svg_cache[name_en] = resolve_svg(name_en, category)
            print(f"  {name_en} -> {svg_cache[name_en]}")

    print(f"\nResolved {len(svg_cache)} unique icons")

    for svg_name in set(svg_cache.values()):
        png_name = slug(svg_name.replace(".svg", "")) + ".png"
        png_path = ICONS_DIR / png_name
        if png_path.exists():
            png_by_svg[svg_name] = png_name
            continue
        try:
            svg_bytes = download_svg(svg_name)
            svg_to_png(svg_bytes, png_path)
            png_by_svg[svg_name] = png_name
            print(f"Downloaded {png_name}")
        except Exception as exc:
            print(f"FAIL {svg_name}: {exc}")
        time.sleep(DELAY)

    default_png = ICONS_DIR / "default.png"
    if not default_png.exists():
        make_default_icon(default_png)

    blocks = []
    for name, category, code, code_display, desc, name_en, desc_en in entries:
        svg_name = svg_cache[name_en]
        icon_file = png_by_svg.get(svg_name, "default.png")
        blocks.append(
            f'"{name}", Map(\n'
            f'    "Category", "{category}",\n'
            f'    "Code", "{code}",\n'
            f'    "CodeDisplay", "{code_display}",\n'
            f'    "Description", "{desc}",\n'
            f'    "NameEn", "{name_en}",\n'
            f'    "DescriptionEn", "{desc_en}",\n'
            f'    "IconFile", "{icon_file}"\n'
            f')'
        )

    header = text.split('"Metralhadora MG-43"')[0]
    header = re.sub(
        r"; Dados sincronizados.*\n; Uma entrada.*\n",
        "; Synced with helldivers.wiki.gg — icons in /icons\n",
        header,
        count=1,
    )
    out = header + ",\n".join(blocks) + ",\n)\n"
    DATA_FILE.write_text(out, encoding="utf-8", newline="\n")
    print(f"\nPatched {DATA_FILE} ({len(blocks)} entries)")


if __name__ == "__main__":
    main()
