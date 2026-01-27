# LibSpellDB Changelog

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
