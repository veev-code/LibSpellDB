#!/usr/bin/env python3
"""
LibSpellDB Icon Color Generator

Extracts a vibrant representative color from each spell's icon and emits a
Lua table (Data/SpellColors.lua) mapping spellID -> {r, g, b}. VeevHUD's
Aura Tracker uses this as the default bar fill color (user override wins).

Pipeline:
  1. Parse every spellID from the Data/*.lua files.
  2. Resolve each spellID -> icon name via the Wowhead cache (wowhead_cache.json).
  3. Decode ICONS/<iconname>.tga (Pillow) and extract a vibrant, center-weighted
     dominant-hue color (so the subject wins over edge fx / dark borders).
  4. Write Data/SpellColors.lua.

Color algorithm (tuned against sniff tests — Slice and Dice=orange,
Enrage=orange, Flurry=red, Blood Craze=green):
  - crop 10% border, keep opaque pixels
  - per-pixel weight = saturation^1.5 * value * center_gaussian(sigma=0.40)
  - histogram by hue (36 bins, circular smoothing), pick peak, average the
    peak +/-1 bins; floor S/V so the color reads on a bar.

Usage:
  python generate_icon_colors.py --report      # coverage + sniff test, no write
  python generate_icon_colors.py --write        # generate Data/SpellColors.lua
"""

import argparse, json, os, re, sys
from pathlib import Path
import numpy as np
from PIL import Image

SCRIPT_DIR = Path(__file__).parent
DATA_DIR = SCRIPT_DIR.parent / "Data"
CACHE_FILE = SCRIPT_DIR / "wowhead_cache.json"
ICONS_DIR = Path(r"C:\Games\World of Warcraft\_anniversary_\Interface\ICONS")
OUT_FILE = DATA_DIR / "SpellColors.lua"

# Spell-bearing data files: all Data/*.lua except the item/color tables. Globbed
# (not hard-coded) so new spell files are picked up automatically and stay in
# lockstep with Tools/validate_spells.py's color-coverage check.
_NON_SPELL_FILES = {"Trinkets.lua", "Potions.lua", "Consumables.lua", "SpellColors.lua"}
SPELL_FILES = sorted(f.name for f in DATA_DIR.glob("*.lua") if f.name not in _NON_SPELL_FILES)

# Neutral grey assigned to any spell whose icon can't be sampled (no icon name,
# no .tga, or unreadable/black/transparent). Guarantees every DB spell gets an
# entry so coverage is always complete and the CI coverage check stays fixable.
FALLBACK_COLOR = (0.6, 0.6, 0.6)

# ─── Lua spellID parsing (depth-tracking, matches wowhead_audit.py) ───────────

def parse_spell_ids(filepath):
    ids = []
    depth = 0
    for line in open(filepath, encoding="utf-8"):
        code = line.split("--")[0]
        m = re.match(r"^(\s+)spellID\s*=\s*(\d+)", line)
        if m and depth == 2 and len(m.group(1)) == 8:
            ids.append(int(m.group(2)))
        depth += code.count("{") - code.count("}")
    return ids

# ─── Icon index (case-insensitive) ───────────────────────────────────────────

def build_icon_index():
    idx = {}
    for f in os.listdir(ICONS_DIR):
        if f.lower().endswith(".tga"):
            idx[f[:-4].lower()] = f
    return idx

def resolve_tga(icon_index, icon):
    """Map a Wowhead icon name to a .tga filename, with known fallbacks:
    Wowhead prefixes some Classic variants with 'classic_' and renders '&' as '-'."""
    icon = icon.lower()
    if icon in icon_index: return icon_index[icon]
    if icon.startswith("classic_"):
        alt = icon[len("classic_"):]
        if alt in icon_index: return icon_index[alt]
    if "-" in icon:
        alt = icon.replace("-", "&")
        if alt in icon_index: return icon_index[alt]
    return None

# ─── Color extraction ────────────────────────────────────────────────────────

def rgb_to_hsv_np(rgb):
    r,g,b = rgb[:,0],rgb[:,1],rgb[:,2]
    mx = np.max(rgb,axis=1); mn = np.min(rgb,axis=1); df = mx-mn
    h = np.zeros_like(mx); nz = df > 1e-6
    idx = nz & (mx==r); h[idx] = ((g[idx]-b[idx])/df[idx]) % 6
    idx = nz & (mx==g) & (mx!=r); h[idx] = ((b[idx]-r[idx])/df[idx]) + 2
    idx = nz & (mx==b) & (mx!=r) & (mx!=g); h[idx] = ((r[idx]-g[idx])/df[idx]) + 4
    return (h/6.0) % 1.0, np.where(mx>1e-6, df/np.maximum(mx,1e-6), 0), mx

def hsv_to_rgb(h,s,v):
    i=int(h*6); f=h*6-i; i%=6
    p=v*(1-s); q=v*(1-f*s); t=v*(1-(1-f)*s)
    return [(v,t,p),(q,v,p),(p,v,t),(p,q,v),(t,p,v),(v,p,q)][i]

def _perceived_lum(r,g,b):
    # sRGB relative luminance — how bright the eye reads a color
    return 0.2126*r + 0.7152*g + 0.0722*b

def _warm_brighten(ch, cs, cv, target=0.72, lo_hue=16, hi_hue=68, min_sat=0.66):
    # Saturated warm hues (orange/gold) read dimmer than their value implies
    # because their green channel is low. For warm hues only, drop saturation
    # just enough to reach a perceived-luminance target — keeping the HIGHEST
    # saturation that still meets it. A saturation floor stops deep oranges
    # (which would need heavy desaturation) from washing out to pale peach;
    # they land a touch under target but keep their color. Other hues unchanged.
    hue_deg = ch * 360.0
    r,g,b = hsv_to_rgb(ch, cs, cv)
    if not (lo_hue <= hue_deg <= hi_hue) or _perceived_lum(r,g,b) >= target:
        return (r,g,b)
    lo, hi = 0.0, cs
    for _ in range(14):
        mid = (lo + hi) / 2.0
        rr,gg,bb = hsv_to_rgb(ch, mid, cv)
        if _perceived_lum(rr,gg,bb) >= target:
            lo = mid
        else:
            hi = mid
    return hsv_to_rgb(ch, min(max(lo, min_sat), cs), cv)

def extract_color(path, svexp=(1.5,1.0), csigma=0.40, minS=0.12, minV=0.12,
                  floorS=0.70, capS=0.95, floorV=1.0):
    img = Image.open(path).convert("RGBA")
    w,hh = img.size
    m = int(round(min(w,hh)*0.10))
    if m: img = img.crop((m,m,w-m,hh-m))
    arr = np.asarray(img).astype(np.float32)/255.0
    H,W = arr.shape[0], arr.shape[1]
    yy,xx = np.mgrid[0:H,0:W].astype(np.float32)
    cy,cx,half = (H-1)/2.0,(W-1)/2.0,(min(H,W)/2.0)
    cw = np.exp(-(((yy-cy)**2+(xx-cx)**2)/(half*half))/(2*csigma*csigma)).reshape(-1)
    rgb = arr[...,:3].reshape(-1,3); a = arr[...,3].reshape(-1)
    keep = a>0.6; rgb = rgb[keep]; cw = cw[keep]
    if len(rgb)==0: return None
    h,s,v = rgb_to_hsv_np(rgb)
    se,ve = svexp
    weight = (s**se)*(v**ve)*cw
    mask = (s>minS)&(v>minV)
    if mask.sum() < max(8, 0.02*len(rgb)):
        # Achromatic icon (steel/grey): keep it neutral and just brighten —
        # don't fabricate a hue by forcing saturation up.
        w = (v**2)*cw
        if float(w.sum()) <= 1e-9:
            return FALLBACK_COLOR  # all-black / zero-weight icon → neutral grey
        col = np.average(rgb, axis=0, weights=w)
        ch,cs,cv = rgb_to_hsv_np(col.reshape(1,3))
        return hsv_to_rgb(float(ch[0]), min(float(cs[0]), 0.18), max(float(cv[0]), 0.80))
    hm,wm,rgbm = h[mask], weight[mask], rgb[mask]
    bins=36
    bi = np.minimum((hm*bins).astype(int), bins-1)
    bw = np.bincount(bi, weights=wm, minlength=bins)
    bw = bw + 0.5*np.roll(bw,1) + 0.5*np.roll(bw,-1)
    peak = int(np.argmax(bw))
    sel = np.isin(bi, [(peak-1)%bins, peak, (peak+1)%bins])
    col = np.average(rgbm[sel], axis=0, weights=wm[sel])
    ch,cs,cv = rgb_to_hsv_np(col.reshape(1,3))
    ch,cs,cv = float(ch[0]), float(cs[0]), float(cv[0])
    # Vivid + bright finalize: cap over-saturation (reads dark/muddy on warm
    # hues) and lift value so colors pop on a bar.
    cs = min(max(cs, floorS), capS); cv = max(cv, floorV)
    # Warm-hue perceptual brightness correction (orange/gold only).
    return _warm_brighten(ch, cs, cv)

# ─── Main ────────────────────────────────────────────────────────────────────

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--write", action="store_true")
    ap.add_argument("--report", action="store_true")
    args = ap.parse_args()

    cache = {int(k): v for k,v in json.load(open(CACHE_FILE)).items()}
    icon_index = build_icon_index()

    # gather spellIDs per file
    spell_ids = {}
    for fn in SPELL_FILES:
        fp = DATA_DIR / fn
        if fp.exists():
            for sid in parse_spell_ids(fp):
                spell_ids[sid] = fn
    all_ids = sorted(spell_ids)

    missing_icon_name = []   # in DB, not in cache
    missing_tga = set()      # icon name with no tga
    color_by_icon = {}       # iconname -> (r,g,b)
    spell_color = {}         # spellID -> (r,g,b)

    for sid in all_ids:
        entry = cache.get(sid)
        if not entry or not entry.get("icon"):
            missing_icon_name.append(sid); continue
        icon = entry["icon"].lower()
        if icon not in color_by_icon:
            tga = resolve_tga(icon_index, icon)
            if not tga:
                missing_tga.add(icon); continue
            try:
                color_by_icon[icon] = extract_color(ICONS_DIR / tga)
            except Exception as e:
                print(f"  ! {icon}: {e}", file=sys.stderr); continue
        if color_by_icon.get(icon):
            spell_color[sid] = color_by_icon[icon]

    # Guarantee every DB spell has a color: anything we couldn't sample (no icon
    # name, no .tga, or unreadable/black/transparent) gets the neutral fallback.
    # This keeps SpellColors.lua at 100% coverage so the CI check is always
    # satisfiable by regenerating, and no spell is ever silently dropped.
    fallback_ids = [sid for sid in all_ids if sid not in spell_color]
    for sid in fallback_ids:
        spell_color[sid] = FALLBACK_COLOR

    print(f"Spells in DB:        {len(all_ids)}")
    print(f"Colored (sampled):   {len(spell_color) - len(fallback_ids)}")
    print(f"Fallback (no icon):  {len(fallback_ids)}" + (f"  e.g. {fallback_ids[:8]}" if fallback_ids else ""))
    print(f"Unique icons:        {len(color_by_icon)}")
    print(f"Missing icon name:   {len(missing_icon_name)} (not in wowhead cache)")
    print(f"Missing .tga file:   {len(missing_tga)}")
    if missing_tga:
        print("  e.g.:", ", ".join(sorted(missing_tga)[:10]))

    # sniff test
    print("\nSniff test:")
    for nm, sid, exp in [("Slice and Dice",5171,"yellow/orange"),
                         ("Enrage",14204,"yellow/orange"),
                         ("Flurry",12970,"red"),
                         ("Blood Craze",16491,"green")]:
        c = spell_color.get(sid)
        if c:
            print(f"  {nm:14s} -> rgb=({int(c[0]*255):3d},{int(c[1]*255):3d},{int(c[2]*255):3d})  expect {exp}")
        else:
            print(f"  {nm:14s} -> (no color)")

    if args.write:
        lines = ["--[[",
                 "    LibSpellDB - Spell Colors",
                 "",
                 "    AUTO-GENERATED by Tools/generate_icon_colors.py — DO NOT EDIT BY HAND.",
                 "    Regenerate with: python Tools/generate_icon_colors.py --write",
                 "",
                 "    A vibrant representative color extracted from each spell's icon, used",
                 "    by consumers (e.g. VeevHUD's Aura Tracker bars) as a sensible default",
                 "    fill color. Keyed by spellID -> {r, g, b} (0-1).",
                 "]]",
                 "",
                 'local lib = LIBSPELLDB_REGISTRATION  -- set by Core/LibSpellDB.lua only when this copy won LibStub version selection',
                 "if not lib then return end",
                 "",
                 "lib.spellColors = {"]
        for sid in sorted(spell_color):
            r,g,b = spell_color[sid]
            lines.append(f"    [{sid}] = {{{r:.3f}, {g:.3f}, {b:.3f}}},")
        lines.append("}")
        OUT_FILE.write_text("\n".join(lines) + "\n", encoding="utf-8")
        print(f"\nWrote {OUT_FILE} ({len(spell_color)} entries)")

if __name__ == "__main__":
    main()
