# LibSpellDB Agent Instructions

LibSpellDB and the sibling VeevHUD directory are separate Git repositories.
Preserve unrelated work and validate changes in the repository that owns them.

The coordinated, version-controlled addon release workflow is hosted at
`../VeevHUD/.agents/skills/veev-release/SKILL.md`. Use it only when the user
explicitly invokes `/veev-release` or `$veev-release` in the current prompt.
This development-tooling pointer does not create a runtime or API dependency on
VeevHUD; the library remains consumer-agnostic.

Normal development must not edit `CHANGELOG.md`, bump `LibSpellDB.toc`, change
the LibStub minor, commit, push, tag, or publish. Those actions require the
explicit release invocation above.
