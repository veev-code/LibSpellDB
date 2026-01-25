# TBC Classic Procs Reference

This document lists important proc buffs for each class that are worth tracking in VeevHUD.

## Warrior

| Proc | Spell ID | Duration | Notes |
|------|----------|----------|-------|
| Enrage | 14204 | 12s | Fury talent, procs on crit when taking damage |
| Flurry | 12970 | 15s | Attack speed buff, stacks 3x, procs on crit |
| Rampage | 30031 | 30s | Buff from Rampage ability (29801), stacks 5x |

## Rogue

| Proc | Spell ID | Duration | Notes |
|------|----------|----------|-------|
| Blade Flurry | 13877 | 15s | Combat talent, cleave attacks |
| Adrenaline Rush | 13750 | 15s | Combat talent, energy regen |
| Slice and Dice | 6774 | 9-21s | Finisher buff, attack speed |
| Find Weakness | 31234 | 10s | Subtlety talent, armor ignore after openers |

## Mage

| Proc | Spell ID | Duration | Notes |
|------|----------|----------|-------|
| Clearcasting | 12536 | 15s | Arcane Concentration proc, free spell |
| Combustion | 28682 | Until 3 crits | Fire talent, stacking crit buff |
| Presence of Mind | 12043 | Until used | Arcane talent, instant cast |
| Arcane Power | 12042 | 15s | Arcane talent, damage buff |
| Icy Veins | 12472 | 20s | Frost talent, haste buff |

## Warlock

| Proc | Spell ID | Duration | Notes |
|------|----------|----------|-------|
| Shadow Trance | 17941 | 10s | Nightfall proc, instant Shadow Bolt |
| Backlash | 34939 | 8s | Destruction talent, instant cast proc |
| Demonic Frenzy | 32851 | Permanent | Demonology pet buff, stacks 10x |

## Priest

| Proc | Spell ID | Duration | Notes |
|------|----------|----------|-------|
| Spirit Tap | 15271 | 15s | Shadow talent, mana regen on kill |
| Surge of Light | 33154 | Until used | Holy talent, instant Flash Heal |
| Inner Focus | 14751 | Until used | Discipline talent, free spell + crit |
| Focused Will | 45242 | 8s | Discipline talent, stacks 3x on crit received, 4% DR + 10% healing |

## Shaman

| Proc | Spell ID | Duration | Notes |
|------|----------|----------|-------|
| Clearcasting | 16246 | 15s | Elemental Focus proc |
| Shamanistic Rage | 30823 | 15s | Enhancement talent, mana + defense |
| Unleashed Rage | 30802 | 10s | Enhancement talent, party AP buff |
| Water Shield | 33736 | 10min | Baseline, mana regen (orbs consumed on hit) |

## Druid

| Proc | Spell ID | Duration | Notes |
|------|----------|----------|-------|
| Clearcasting | 16870 | 15s | Omen of Clarity proc |
| Nature's Grace | 16886 | Until used | Balance talent, faster cast |
| Eclipse | N/A | N/A | Not in TBC |

## Paladin

| Proc | Spell ID | Duration | Notes |
|------|----------|----------|-------|
| Vengeance | 20055 | 8s | Retribution talent, stacking damage buff |
| Art of War | N/A | N/A | Not in TBC (added in WotLK) |

## Hunter

| Proc | Spell ID | Duration | Notes |
|------|----------|----------|-------|
| Quick Shots | 6150 | 12s | Improved Aspect of the Hawk proc |
| The Beast Within | 34471 | 18s | BM talent, damage + immune to CC |
| Bestial Wrath | 19574 | 18s | Pet version of above |
| Improved Kill Command | N/A | N/A | Not a proc, just CD reduction |

---

## Notes

- Spell IDs should be verified in-game using tooltip addons like idTip
- Some procs have multiple ranks; use the highest rank ID
- Buff IDs may differ from ability IDs (e.g., Rampage ability 29801 applies buff 30031)
