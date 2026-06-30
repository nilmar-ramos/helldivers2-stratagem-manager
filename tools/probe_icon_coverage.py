import json, re, urllib.parse, urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "HelldiversData.ahk"

opener = urllib.request.build_opener()
opener.addheaders = [("User-Agent", "HelldiversStratagemTool/1.0")]
urllib.request.install_opener(opener)
_cache = {}


def wiki_file_exists(filename):
    if filename in _cache:
        return _cache[filename]
    url = "https://helldivers.wiki.gg/api.php?" + urllib.parse.urlencode(
        {"action": "query", "titles": f"File:{filename}", "format": "json"}
    )
    with urllib.request.urlopen(url, timeout=20) as r:
        pages = json.load(r)["query"]["pages"]
    ok = any("missing" not in p for p in pages.values())
    _cache[filename] = ok
    return ok


def candidates(name_en):
    out = []
    base = name_en.replace("/", "-")
    out.append(f"{base.replace(' ', '_')}_Stratagem_Icon.svg")
    out.append(f"{name_en.replace(' ', '_')}_Stratagem_Icon.svg")

    # strip leading code tokens
    tokens = name_en.split()
    for i in range(1, min(4, len(tokens))):
        rest = " ".join(tokens[i:])
        out.append(f"{rest.replace(' ', '_')}_Stratagem_Icon.svg")
        out.append(f"{rest.replace(' ', '_')}_Stratagem_Icon_Background.svg")

    # special replacements
    out.append(f"{name_en.split()[-1]}_Stratagem_Icon.svg")
    seen = set()
    for c in out:
        if c not in seen:
            seen.add(c)
            yield c


def parse_name_en(text):
    return re.findall(r'"NameEn",\s*"([^"]+)"', text)


text = DATA.read_text(encoding="utf-8")
names = parse_name_en(text)
found = 0
missing = []
for n in names:
    hit = None
    for c in candidates(n):
        if wiki_file_exists(c):
            hit = c
            break
    if hit:
        found += 1
    else:
        missing.append(n)
print(f"found {found}/{len(names)}")
for m in missing[:30]:
    print("MISSING:", m)
print("total missing", len(missing))
