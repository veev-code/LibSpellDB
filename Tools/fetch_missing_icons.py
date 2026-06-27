#!/usr/bin/env python3
"""Fetch Wowhead icon names for any LibSpellDB spell missing from the cache."""
import json, time, urllib.request, urllib.error, sys
from generate_icon_colors import parse_spell_ids, SPELL_FILES, DATA_DIR, CACHE_FILE

WOWHEAD_URL = "https://nether.wowhead.com/tbc/tooltip/spell/{}"

def fetch(sid, delay=0.15):
    url = WOWHEAD_URL.format(sid)
    for attempt in range(3):
        try:
            req = urllib.request.Request(url, headers={"User-Agent": "LibSpellDB-Audit/1.0"})
            with urllib.request.urlopen(req, timeout=15) as r:
                d = json.loads(r.read().decode("utf-8"))
            time.sleep(delay); return d
        except urllib.error.HTTPError as e:
            if e.code == 404:
                time.sleep(delay); return {"error": "not_found", "spell_id": sid}
            time.sleep(2**(attempt+1))
        except Exception as e:
            time.sleep(2**(attempt+1))
    return {"error": "failed", "spell_id": sid}

def main():
    cache = json.load(open(CACHE_FILE, encoding="utf-8"))
    ids = set()
    for fn in SPELL_FILES:
        fp = DATA_DIR / fn
        if fp.exists():
            ids.update(parse_spell_ids(fp))
    missing = [s for s in sorted(ids)
               if str(s) not in cache or not cache[str(s)].get("icon")]
    print(f"{len(missing)} spells to fetch...")
    for i, sid in enumerate(missing, 1):
        d = fetch(sid)
        cache[str(sid)] = d
        if i % 25 == 0 or i == len(missing):
            json.dump(cache, open(CACHE_FILE,"w",encoding="utf-8"), indent=2, ensure_ascii=False)
            print(f"  {i}/{len(missing)} (last: {sid} -> {d.get('icon') or d.get('error')})")
    json.dump(cache, open(CACHE_FILE,"w",encoding="utf-8"), indent=2, ensure_ascii=False)
    print("done")

if __name__ == "__main__":
    main()
