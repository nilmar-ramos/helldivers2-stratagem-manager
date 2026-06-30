import json, urllib.parse, urllib.request

opener = urllib.request.build_opener()
opener.addheaders = [("User-Agent", "HelldiversStratagemTool/1.0")]
urllib.request.install_opener(opener)

def exists(file):
    url = "https://helldivers.wiki.gg/api.php?" + urllib.parse.urlencode(
        {"action": "query", "titles": f"File:{file}", "prop": "imageinfo", "iiprop": "url", "format": "json"}
    )
    with urllib.request.urlopen(url, timeout=20) as r:
        pages = json.load(r)["query"]["pages"]
    for p in pages.values():
        if "missing" not in p:
            return p["imageinfo"][0]["url"]
    return None

tests = [
    "MG-43 Machine Gun Stratagem Icon.svg",
    "Machine Gun Stratagem Icon.svg",
    "Machine_Gun_Stratagem_Icon_Background.svg",
    "Orbital Precision Strike Stratagem Icon.svg",
    "A/MG-43 Machine Gun Sentry Stratagem Icon.svg",
    "Machine Gun Sentry Stratagem Icon.svg",
    "Machine_Gun_Sentry_Stratagem_Icon_Background.svg",
]
for t in tests:
    fn = t.replace(" ", "_")
    u = exists(fn)
    print(("OK" if u else "NO"), fn)
