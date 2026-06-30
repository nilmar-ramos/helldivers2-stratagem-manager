#!/usr/bin/env python3
"""Add NameEn and DescriptionEn to HelldiversData.ahk from wiki-aligned names."""

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DATA_FILE = ROOT / "HelldiversData.ahk"

# Official English names keyed by Code string (from helldivers.wiki.gg/wiki/Stratagems)
WIKI_BY_CODE = {
    "Down, Left, Down, Up, Right": ("MG-43 Machine Gun", "High fire rate machine gun with slow reload."),
    "Down, Down, Left, Up, Right": ("EAT-17 Expendable Anti-Tank", "Two disposable anti-tank rockets."),
    "Down, Left, Down, Up, Up, Left": ("M-105 Stalwart", "High fire rate support weapon with fast reload."),
    "Down, Left, Down, Up, Left": ("LAS-98 Laser Cannon", "Long-range laser; overheats with sustained fire."),
    "Down, Left, Right, Up, Down": ("APW-1 Anti-Materiel Rifle", "Sniper rifle effective against light armor."),
    "Down, Left, Up, Left, Down": ("GL-21 Grenade Launcher", "High-explosive grenade launcher."),
    "Down, Left, Right, Right, Left": ("GR-8 Recoilless Rifle", "Shoulder-fired recoilless rifle with massive damage."),
    "Down, Left, Up, Down, Up": ("FLAM-40 Flamethrower", "Devastating against bug-type enemies."),
    "Down, Left, Up, Down, Down": ("MG-206 Heavy Machine Gun", "Heavy machine gun with high fire rate."),
    "Down, Left, Down, Up, Up, Right": ("AC-8 Autocannon", "Shoulder-mounted autocannon for anti-vehicle use."),
    "Down, Right, Down, Up, Left, Left": ("ARC-3 Arc Thrower", "Medium-to-long range electrical arc weapon."),
    "Down, Down, Up, Left, Right": ("LAS-99 Quasar Cannon", "Extremely high damage laser cannon."),
    "Down, Up, Up, Left, Right": ("RL-77 Airburst Rocket Launcher", "Rocket launcher with airburst detonation."),
    "Down, Left, Up, Down, Right": ("MLS-4X Commando", "Laser-guided anti-tank launcher; four rockets."),
    "Down, Down, Up, Down, Down": ("FAF-14 Spear", "Homing anti-tank missile with extreme damage."),
    "Down, Right, Down, Up, Left, Right": ("RS-422 Railgun", "Experimental railgun; safe and unsafe firing modes."),
    "Down, Left, Up, Down, Left": ("TX-41 Sterilizer", "Caustic gas that blinds and slows enemies."),
    "Down, Down, Up, Down, Right": ("StA-X3 W.A.S.P. Launcher", "Swarm launcher."),
    "Down, Left, Right, Left, Up": ("CQC-20 Breaching Hammer", "Breaching hammer for close combat."),
    "Down, Left, Up, Left, Right": ("PLAS-45 Epoch", "Plasma weapon."),
    "Down, Left, Down, Right, Up, Left": ("MGX-42 Bullet Storm", "Disposable machine gun."),
    "Down, Right, Down, Left, Up, Right": ("S-11 Speargun", "Underwater-capable speargun."),
    "Down, Left, Right, Right, Down": ("CQC-9 Defoliation Tool", "Heavy defoliation tool."),
    "Down, Down, Left, Up, Left": ("EAT-700 Expendable Napalm", "Disposable napalm launcher."),
    "Down, Down, Left, Up, Down": ("EAT-411 Leveller", "Disposable levelling explosive."),
    "Down, Right, Up, Left, Right": ("GL-52 De-Escalator", "Grenade launcher."),
    "Down, Left, Up, Left, Up, Up": ("GL-28 Belt-Fed Grenade Launcher", "Belt-fed grenade launcher."),
    "Down, Right, Up, Up, Right, Up": ("B/MD C4 Pack", "Remote-detonated C4 pack."),
    "Down, Up, Right, Down, Down": ("MS-11 Solo Silo", "Single-use missile silo."),
    "Down, Down, Right, Down, Up, Up": ("B/FLAM-80 Cremator", "Heavy flamethrower."),
    "Down, Left, Right, Down, Up, Up": ("M-1000 Maxigun", "High-damage minigun."),
    "Down, Left, Right, Right, Up": ("CQC-1 One True Flag", "Combat flag."),
    "Down, Left, Down, Up, Up, Down": ("B-1 Supply Pack", "Backpack with ammo resupply bags."),
    "Down, Left, Down, Down, Up, Left": ("SH-20 Ballistic Shield Backpack", "One-handed ballistic shield."),
    "Down, Up, Left, Up, Right, Down": ("AX/AR-23 Guard Dog", "Automaton drone with Liberator rifle."),
    "Down, Up, Left, Up, Right, Right": ("AX/LAS-5 Rover", "Automaton drone with laser."),
    "Down, Up, Left, Right, Left, Right": ("SH-32 Shield Generator Pack", "Bubble shield over the Helldiver."),
    "Down, Up, Left, Right, Up, Up": ("SH-51 Directional Shield", "Directional shield backpack."),
    "Down, Up, Left, Up, Left, Left": ("AX/FLAM-75 Hot Dog", "Guard Dog with flamethrower."),
    "Down, Right, Up, Up, Up": ("B-100 Portable Hellbomb", "Portable hellbomb."),
    "Down, Up, Left, Up, Right, Left": ("AX/ARC-3 K-9", "Guard Dog with arc thrower."),
    "Down, Up, Left, Up, Right, Up": ("AX/TX-13 Dog Breath", "Guard Dog with caustic gas."),
    "Down, Up, Up, Down, Up": ("LIFT-850 Jump Pack", "Jump pack; no fall damage."),
    "Down, Up, Up, Down, Left, Right": ("LIFT-860 Hover Pack", "Hover mobility pack."),
    "Down, Left, Right, Down, Left, Right": ("LIFT-182 Warp Pack", "Warp teleport pack."),
    "Left, Down, Right, Up, Left, Down, Down": ("EXO-45 Patriot Exosuit", "Exosuit with machine gun and rockets."),
    "Left, Down, Right, Up, Left, Down, Up": ("EXO-49 Emancipator Exosuit", "Exosuit with dual autocannons."),
    "Left, Down, Right, Left, Right, Down, Up": ("EXO-55 Breakthrough Exosuit", "Breakthrough exosuit."),
    "Left, Down, Right, Up, Right, Left, Up": ("EXO-51 Lumberer Exosuit", "Lumberer exosuit."),
    "Left, Down, Right, Down, Right, Down, Up": ("M-102 Fast Recon Vehicle", "Fast recon vehicle."),
    "Left, Down, Left, Left, Down, Up, Right": ("M-103 Supply FRV", "Supply fast recon vehicle."),
    "Left, Down, Right, Left, Down, Up, Up": ("M-104 Incinerator FRV", "Incinerator fast recon vehicle."),
    "Left, Down, Right, Down, Left, Down, Up, Down, Up": ("TD-220 Bastion MK XVI", "Heavy armored vehicle."),
    "Up, Down, Right, Left, Up": ("Reinforce", "Brings fallen Helldivers back."),
    "Up, Down, Right, Up": ("SOS Beacon", "Fills empty squad slots."),
    "Down, Down, Up, Right": ("Resupply", "Ammo resupply pod."),
    "Up, Up, Left, Up, Right": ("Eagle Rearm", "Rearms Eagle stratagem payloads."),
    "Down, Up, Left, Down, Up, Right, Down, Up": ("NUX-223 Hellbomb", "Hellbomb for mission objectives."),
    "Down, Down, Down, Up, Up": ("SSSD Delivery", "Special supply delivery."),
    "Up, Up, Left, Right, Down, Down": ("Seismic Probe", "Detects seismic activity."),
    "Left, Right, Up, Up, Up": ("Upload Data", "Uploads mission data."),
    "Right, Right, Left, Left": ("Orbital Illumination Flare", "Illumination flare signal."),
    "Right, Up, Up, Down": ("SEAF Artillery", "SEAF fleet artillery strike."),
    "Down, Up, Down, Up": ("Super Earth Flag", "Plants the Super Earth flag."),
    "Up, Left, Right, Down, Up, Up": ("Dark Fluid Vessel", "Dark Fluid containment vessel."),
    "Up, Down, Up, Down, Up, Down": ("Tectonic Drill", "Tectonic drill for missions."),
    "Left, Up, Down, Right, Down, Down": ("Hive Breaker Drill", "Anti-hive drill."),
    "Down, Down, Left, Right, Down, Down": ("Prospecting Drill", "Prospecting drill."),
    "Down, Up, Right, Right, Up": ("A/MG-43 Machine Gun Sentry", "Automated machine gun sentry."),
    "Down, Up, Right, Left": ("A/G-16 Gatling Sentry", "High RPM gatling sentry."),
    "Down, Up, Right, Right, Down": ("A/M-12 Mortar Sentry", "Long-range mortar sentry."),
    "Down, Up, Right, Up, Left, Up": ("A/AC-8 Autocannon Sentry", "Anti-armor autocannon sentry."),
    "Down, Up, Right, Right, Left": ("A/MLS-4X Rocket Sentry", "Rocket launcher sentry."),
    "Down, Up, Right, Down, Right": ("A/M-23 EMS Mortar Sentry", "Stun mortar sentry."),
    "Down, Up, Right, Down, Up, Right": ("A/LAS-98 Laser Sentry", "Laser sentry turret."),
    "Down, Up, Right, Down, Up, Up": ("A/FLAM-40 Flame Sentry", "Flamethrower sentry."),
    "Down, Up, Right, Down, Left": ("A/GM-17 Gas Mortar Sentry", "Gas mortar sentry."),
    "Down, Up, Right, Up, Left, Right": ("A/ARC-3 Tesla Tower", "Electrical arc tower."),
    "Down, Left, Up, Right": ("MD-6 Anti-Personnel Minefield", "Anti-personnel mines."),
    "Down, Left, Left, Down": ("MD-I4 Incendiary Mines", "Incendiary mines."),
    "Down, Left, Up, Up": ("MD-17 Anti-Tank Mines", "Anti-tank mines."),
    "Down, Left, Left, Right": ("MD-8 Gas Mines", "Gas mines."),
    "Down, Down, Left, Right, Left, Right": ("FX-12 Shield Generator Relay", "Large shield bubble relay."),
    "Down, Up, Left, Right, Right, Left": ("E/MG-101 HMG Emplacement", "Manned HMG emplacement."),
    "Down, Right, Down, Left, Right": ("E/GL-21 Grenadier Battlement", "Grenade launcher emplacement."),
    "Down, Up, Left, Right, Right, Right": ("E/AT-12 Anti-Tank Emplacement", "Anti-tank emplacement."),
    "Right, Right, Up": ("Orbital Precision Strike", "Single precision orbital shot."),
    "Right, Down, Left, Up, Up": ("Orbital Gatling Barrage", "High rate-of-fire orbital barrage."),
    "Right, Right, Down, Right": ("Orbital Gas Strike", "Poison gas strike."),
    "Right, Right, Down, Left, Right, Down": ("Orbital 120mm HE Barrage", "Heavy 120mm barrage."),
    "Right, Right, Right": ("Orbital Airburst Strike", "Lethal shrapnel airburst."),
    "Right, Right, Down, Up": ("Orbital Smoke Strike", "Smoke screen; blocks line of sight."),
    "Right, Right, Left, Down": ("Orbital EMS Strike", "Stunning static cloud."),
    "Right, Down, Up, Up, Left, Down, Down": ("Orbital 380mm HE Barrage", "Large-area heavy barrage."),
    "Right, Down, Right, Down, Right, Down": ("Orbital Walking Barrage", "Walking barrage pattern."),
    "Right, Down, Up, Right, Down": ("Orbital Laser", "High-power orbital laser."),
    "Right, Right, Down, Left, Right, Up": ("Orbital Napalm Barrage", "Napalm barrage."),
    "Right, Up, Down, Down, Right": ("Orbital Railcannon Strike", "Orbital railcannon strike."),
    "Up, Right, Right": ("Eagle Strafing Run", "Quick strafing run against small targets."),
    "Up, Right, Down, Right": ("Eagle Airstrike", "Bombing run."),
    "Up, Right, Down, Down, Right": ("Eagle Cluster Bomb", "Cluster bomb drop."),
    "Up, Right, Down, Up": ("Eagle Napalm Airstrike", "Horizontal napalm strike."),
    "Up, Right, Up, Down": ("Eagle Smoke Strike", "Smoke cloud strike."),
    "Up, Right, Up, Left": ("Eagle 110mm Rocket Pods", "Concentrated rocket pods."),
    "Up, Right, Down, Down, Down": ("Eagle 500kg Bomb", "Extreme damage bomb."),
}


def parse_entries(text: str):
    pattern = re.compile(
        r'"([^"]+)",\s*Map\(\s*'
        r'"Category",\s*"([^"]+)",\s*'
        r'"Code",\s*"([^"]+)",\s*'
        r'"CodeDisplay",\s*"([^"]+)",\s*'
        r'"Description",\s*"([^"]+)"',
        re.MULTILINE,
    )
    return pattern.findall(text)


def esc(s: str) -> str:
    return s.replace("\\", "\\\\").replace('"', '\\"')


def main():
    text = DATA_FILE.read_text(encoding="utf-8")
    entries = parse_entries(text)
    missing = []
    new_blocks = []

    for name, category, code, code_display, desc in entries:
        if code not in WIKI_BY_CODE:
            missing.append((name, code))
            name_en, desc_en = name, desc
        else:
            name_en, desc_en = WIKI_BY_CODE[code]

        block = (
            f'"{esc(name)}", Map(\n'
            f'    "Category", "{esc(category)}",\n'
            f'    "Code", "{esc(code)}",\n'
            f'    "CodeDisplay", "{esc(code_display)}",\n'
            f'    "Description", "{esc(desc)}",\n'
            f'    "NameEn", "{esc(name_en)}",\n'
            f'    "DescriptionEn", "{esc(desc_en)}"\n'
            f')'
        )
        new_blocks.append(block)

    header = text.split('"Metralhadora MG-43"')[0]
    if "NameEn" in header:
        header = re.sub(
            r"global STRATAGEM_DATA := Map\(\r?\n;[^\n]*\r?\n;[^\n]*\r?\n",
            "global STRATAGEM_DATA := Map(\n; Synced with helldivers.wiki.gg — PT keys, EN via NameEn/DescriptionEn\n",
            header,
            count=1,
        )

    out = header + ",\n".join(new_blocks) + ",\n)\n"
    DATA_FILE.write_text(out, encoding="utf-8", newline="\n")

    print(f"Updated {len(new_blocks)} entries in {DATA_FILE}")
    if missing:
        print(f"WARNING: {len(missing)} codes missing from wiki map:")
        for n, c in missing:
            print(f"  - {n}: {c}")


if __name__ == "__main__":
    main()
