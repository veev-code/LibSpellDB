# LibSpellDB

**A shared spell database library for World of Warcraft addon developers, featuring a composable tagging system for granular spell queries.**

## Overview

LibSpellDB was originally built to power [VeevHUD](https://www.curseforge.com/wow/addons/veevhud) but is designed as a generic, reusable library that any addon can leverage. It provides a centralized, curated repository of spell data including:

*   Cooldowns and durations
*   Buff/debuff associations (when the applied aura uses a different spellId than the ability)
*   Spell ranks (mapping all ranks to a canonical spell ID)
*   Proc information
*   Spec relevance
*   Extensive tagging for categorization

## The Composable Tagging Approach

Rather than rigid categories, LibSpellDB uses a **composable tag system** that allows granular, flexible queries. Each spell can have multiple tags that describe different aspects of what it does and how it's used.

### Role Tags

Define what type of throughput the ability provides:

*   `DPS` — Deals or increases damage
*   `HEAL` — Heals or increases healing output
*   `TANK` — Tank-specific ability

### Usage Pattern Tags

Describe how/when you use the ability:

*   `ROTATIONAL` — Core rotation, used on cooldown
*   `MAINTENANCE` — Buff/debuff to keep active
*   `MINOR` — Short cooldown (<60s), tactical usage
*   `MAJOR` — Long cooldown (60s+), save for key moments
*   `AOE` — AoE-focused ability

### Defensive Tags

*   `DEFENSIVE` — Reduces damage taken
*   `PERSONAL_DEFENSIVE` — Self-survival cooldowns
*   `EXTERNAL_DEFENSIVE` — Defensives castable on others
*   `IMMUNITY` — Full immunity effects
*   `DAMAGE_REDUCTION` — Flat damage reduction

### Crowd Control Tags

*   `INTERRUPT` — Spell interrupts
*   `CC_HARD` — Stuns, incapacitates, polymorphs
*   `CC_SOFT` — Slows, snares, roots
*   `SILENCE` — Silence effects
*   `FEAR` — Fear effects
*   `CC_BREAK` — Breaks CC (trinket, Berserker Rage)
*   `CC_IMMUNITY` — Prevents CC application

### Movement Tags

*   `MOVEMENT` — General movement abilities
*   `MOVEMENT_GAP_CLOSE` — Charges, blinks, leaps
*   `MOVEMENT_ESCAPE` — Disengages, vanishes

### Utility Tags

*   `DISPEL_MAGIC`, `DISPEL_CURSE`, `DISPEL_POISON`, `DISPEL_DISEASE` — Dispel types
*   `PURGE` — Offensive dispel (removes enemy buffs)
*   `TAUNT` — Threat/taunt abilities
*   `RESOURCE` — Resource generation/management
*   `UTILITY` — General utility

### Mechanic Tags

*   `REACTIVE` — Conditional abilities (Overpower, Execute, Revenge)
*   `PROC` — Proc-based buffs to track
*   `FINISHER` — Combo point/resource spenders
*   `HAS_BUFF`, `HAS_DEBUFF`, `HAS_DOT`, `HAS_HOT` — Describes what the spell applies

## Query Examples

```
local LibSpellDB = LibStub("LibSpellDB-1.0")

-- Get all warrior spells
local warriorSpells = LibSpellDB:GetSpellsByClass("WARRIOR")

-- Get all interrupts
local interrupts = LibSpellDB:GetSpellsByTag("INTERRUPT")

-- Get warrior interrupts specifically
local warriorInterrupts = LibSpellDB:GetSpellsByClassAndTag("WARRIOR", "INTERRUPT")

-- Get spells matching ANY of these tags (union)
local ccAbilities = LibSpellDB:GetSpellsByTags({"CC\_HARD", "CC\_SOFT", "INTERRUPT"})

-- Get spells matching ALL of these tags (intersection)
local rotationalDps = LibSpellDB:GetSpellsByAllTags({"ROTATIONAL", "DPS"})

-- Check if a spell has a specific tag
if LibSpellDB:HasTag(6552, "INTERRUPT") then
    -- Pummel is an interrupt
end
```

## Spell Data Structure

Each spell entry supports the following fields:

```lua
{
    spellID = 12345,           -- Required: Primary spell ID
    class = "WARRIOR",         -- Required: Class token (or "SHARED" for racials)
    tags = {"DPS", "ROTATIONAL"},  -- Required: Category tags
    cooldown = 10,             -- Optional: Base cooldown in seconds
    duration = 5,              -- Optional: Buff/effect duration
    priority = 1,              -- Optional: Sort priority within rows
    talent = true,             -- Optional: Requires talent
    ranks = {100, 101, 102},   -- Optional: All rank spell IDs (low to high)
    specs = {"ARMS", "FURY"},  -- Optional: Which specs use this (nil = all)
    race = "Orc",              -- Optional: Race restriction for racials
    selfOnly = true,           -- Optional: Buff can ONLY target self (default: inferred from tags)
    ignoreAura = true,         -- Optional: Don't track this spell's buff/debuff
    triggersAuras = {...},     -- Optional: Auras this spell triggers (with different IDs)
    targetLockoutDebuff = 6788,-- Optional: Debuff that blocks re-casting (e.g., Weakened Soul)
    sharedCooldownGroup = "...",  -- Optional: Shared CD group name
}
```

### The `selfOnly` Field

The `selfOnly` field controls how buff tracking behaves when targeting friendly players:

*   `selfOnly = true` — Buff always displays your own status, regardless of target
*   `selfOnly = false` — Buff checks the relevant friendly target (ally if targeting one)
*   `selfOnly = nil` (default) — Inferred from tags:
    *   Spells with `HEAL_SINGLE`, `HOT`, `HAS_HOT`, `HEAL_AOE`, or `EXTERNAL_DEFENSIVE` → can target others
    *   All other buffs → self-only

**Examples:**
*   Power Word: Shield, Renew, Blessing of Protection → can target others (check ally when targeting them)
*   Recklessness, Shadowform, Stealth → self-only (always show your own buff)

## Current Coverage

LibSpellDB currently includes comprehensive spell data for all TBC Classic classes. Each class includes rotational abilities, cooldowns, utility, CC, defensives, and more — all properly tagged for flexible querying.

## For Addon Developers

LibSpellDB is distributed as a standalone library. To use it in your addon:

1.  Include LibSpellDB as a dependency or embed it
2.  Access via LibStub: local LibSpellDB = LibStub("LibSpellDB-1.0")
3.  Query spells using the API methods above

The library handles spell validation automatically — spells that don't exist in the current game version are silently skipped.

## Feedback & Bug Reports

Join the **Veev Addons Discord** for feedback, suggestions, and bug reports: [https://discord.gg/HuSXTa5XNq](https://discord.gg/HuSXTa5XNq)