# Frozen Passage — User Review Checklist

Review the deployed build at <https://frozen-passage.onrender.com>. This checklist is for the user's browser review; the agent has not performed interactive gameplay or listening checks.

The Passage 2 completion fix described in `docs/qa_report.md` is deployed in commit `8dcd792`. Review the current live build to confirm Passage 2 remains playable after the transition and reaches completion only at its exit.

For each item, mark **Works**, **Issue**, or **Not tried**. Include what happened and the key/input used for any issue.

## Browser and controls

- [ ] The game loads and shows the winter route and HUD.
- [ ] At 960×540, the route, controls, timer, and HUD are readable.
- [ ] At 640×360, the route and HUD remain readable and usable.
- [ ] Left/right movement and Space/W/Up jump work; falling returns to the start.

## Speedrun course

- [ ] The timer starts when movement begins, continues through a fall and Passage 1→2, and freezes at the finish.
- [ ] Moving platforms are readable; the player can land, ride, jump off, and recover after a fall.
- [ ] The marked DASH point unlocks dash; Shift dashes in the facing direction and the HUD shows its cooldown/readiness.
- [ ] Finishing shows the run time and best time; restart returns to Passage 1 with a fresh timer and dash relocked.

## Music

- [ ] Music starts during the run and continues after a fall.
- [ ] Mute/volume controls respond and keep their settings after restarting or reloading.
- [ ] Music stops after completion; note any audio quality, volume, or looping issue.

## Feedback to send

- Browser and operating system:
- Viewport size(s) tried:
- Checklist item(s) with issues:
- Steps and keys that reproduced each issue:
- Suggested change or other feature request:
