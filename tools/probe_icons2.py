import json, re, urllib.parse, urllib.request

opener = urllib.request.build_opener()
opener.addheaders = [("User-Agent", "HelldiversStratagemTool/1.0")]
urllib.request.install_opener(opener)

url = "https://helldivers.wiki.gg/api.php?" + urllib.parse.urlencode(
    {"action": "parse", "page": "MG-43_Machine_Gun", "prop": "text", "format": "json"}
)
with urllib.request.urlopen(url, timeout=20) as r:
    text = json.load(r)["parse"]["text"]["*"]

for pat in [
    r"infobox[^>]*>.*?</table>",
    r"Stratagem Icon[^\"']*",
    r"images/[^\"'\s>]+\.(?:svg|png)",
]:
    pass

files = sorted(set(re.findall(r"(?:File:|/images/)([^\"'\s|>?#]+\.(?:svg|png))", text, re.I)))
for f in files:
    print(f)
