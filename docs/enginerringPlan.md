# Engineering and Quality Standards

## 1. Development philosophy

Build a small, polished and maintainable game.

Prefer simple, readable code over clever abstractions.

Do not over-engineer.

## 2. Single Responsibility Principle

Every script must have one clearly defined responsibility.

- Player movement must not implement health logic.
- Health components must not update UI directly.
- Animation logic must not implement gameplay mechanics.
- Enemy AI must not control player state.
- Map transitions must not manage checkpoint persistence.
- Audio systems must not contain gameplay rules.

Use signals for communication between independent components.

## 3. Asset sourcing

- Use the supplied asset links and visual references.
- Inspect asset previews before selecting resources.
- Prefer original, non-generative artwork and consistent asset packs.
- Never mix incompatible visual styles.
- Never use assets without checking their licenses.
- Maintain an asset manifest with source URLs, creator and license.
- Do not generate AI artwork unless explicitly requested.

## 4. Audio

- No AI-generated music.
- No runtime music-generation APIs.
- Use human-composed, appropriately licensed music.
- Prefer CC0 tracks or original compositions.
- Use separate ambient and music tracks for each map.
- Use simple crossfades between maps.
- Keep audio playback logic inside AudioManager.

## 5. Testing and reward function

Every feature must have:
- A clear requirement.
- An implementation.
- An acceptance test.
- A recorded test result.

Maintain a QA scorecard with:
- Gameplay: 30 points.
- Level design: 20 points.
- Code quality: 20 points.
- Visuals and audio: 10 points.
- UI: 10 points.
- Deployment: 10 points.

Mandatory gameplay and deployment requirements must never be overridden by a high aggregate score.

## 6. Development workflow

For every milestone:

1. Read the game design and architecture documents.
2. Implement only the current milestone.
3. Run static checks and automated tests.
4. Launch the game and verify functionality.
5. Update acceptance criteria.
6. Update QA scorecard.
7. Document failures and unresolved issues.
8. Only then proceed to the next milestone.

Never mark an untested feature as complete.

## 7. Documentation

Maintain:
- docs/game_design.md
- docs/architecture.md
- docs/asset_manifest.md
- docs/acceptance_criteria.md
- docs/qa_report.md
- docs/deployment.md

Keep documentation synchronized with the actual implementation.

## 8. Code review

Before completing each milestone, check:
- Are scripts doing more than one job?
- Are there unnecessary abstractions?
- Are there duplicated gameplay rules?
- Are signals used appropriately?
- Are magic numbers configurable?
- Are errors and edge cases handled?
- Can another developer understand the code easily?

Do not refactor working code without a concrete reason.