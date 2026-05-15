import re
import pathlib

text = pathlib.Path("_meta.lua").read_text(encoding="utf-8")
m = re.search(r'version\s*=\s*"([^"]+)"', text)
print(m.group(1) if m else "0.0.0")
