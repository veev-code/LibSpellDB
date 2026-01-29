# LibSpellDB Changelog

## [1.0.9] - 2026-01-28

### Fixed
- Include spell data files in `lib.xml` so embedded copies (e.g., bundled with VeevHUD) load correctly
- Previously, only the core library loaded when embedded, resulting in zero spells being registered

## [1.0.8] - 2026-01-28

### Added
- Deep Wounds proc tracking for Warriors (target debuff)
- `ignoreAura` flag for spells where cooldown tracking is more relevant than debuff tracking (e.g., Mortal Strike)

## [1.0.7] - 2026-01-27

### Added
- `lib.Specs` constants for type-safe spec tagging in data files
- All spells now have explicit `specs` field (no more implicit "all specs" behavior)

### Changed
- Data files now use `S.ARMS`, `S.SHADOW`, etc. instead of string literals
- Reduces typo risk and enables IDE autocomplete for spec names

## [1.0.6] - 2026-01-27

### Added
- `GetAllRankIDs(spellID)` - Returns set of all rank spell IDs for a spell
- `GetHighestKnownRank(spellID)` - Returns highest rank the player knows

These utility functions enable addons to accurately determine spell costs and usability for ranked spells.

## [1.0.5] - 2026-01-27

### Changed
- Updated changelog for CurseForge

## [1.0.4] - 2026-01-27

### Fixed
- Added Mocking Blow ranks for proper debuff tracking

## [1.0.3] - 2026-01-25

### Fixed
- Added Charge Stun and Intercept Stun aura mappings for Warriors

## [1.0.2] - 2026-01-25

### Fixed
- CurseForge publishing configuration

## [1.0.1] - 2026-01-24

### Fixed
- TBC Classic interface version

## [1.0.0] - 2025-01-24

### Added
- Initial release
- Complete spell database for all TBC Classic classes
- Spec detection and filtering
- Category/tag system for spell classification
- Proc tracking data for all classes
- Shared cooldown group support
- PvE and PvP rotation tags
- Reactive ability detection
