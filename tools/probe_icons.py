import json, re, urllib.parse, urllib.request

opener = urllib.request.build_opener()
opener.addheaders = [("User-Agent", "HelldiversStratagemTool/1.0")]
urllib.request.install_opener(opener)

pages = ["MG-43_Machine_Gun", "Reinforce", "A_G-16_Gatling_Sentry"]
for page in pages:
    url = "https://helldivers.wiki.gg/api.php?" + urllib.parse.urlencode(
        {"action": "parse", "page": page, "prop": "text", "format": "json"}
    )
    with urllib.request.urlopen(url, timeout=20) as r:
        text = json.load(r)["parse"]["text"]["*"]
    imgs = re.findall(r"(?:File:|images/)([^\"'\s|>]+Stratagem[^\"'\s|>]*)", text)
    print(page, "->", imgs[:3])
