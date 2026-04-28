# JianghuQunxiaZhuanReborn Roadmap

Goal: build a playable SwiftUI single-player wuxia RPG prototype with a JY3-style system structure.

## Phase 1: Running Project Foundation

Objective: make the project easy to open, run, and continue building.

Tasks:

1. Add a simple Swift Package or XcodeGen project structure.
2. Keep all Swift source under clean App, Core, Systems, Resources directories.
3. Add a minimal app entry, root view, engine, and default content.
4. Add README running instructions.
5. Add local save/load support.

Acceptance:

- A developer can clone the repo and understand how to open or generate the iOS project.
- The app has a root SwiftUI screen and compile-oriented source organization.

## Phase 2: JY3-style Core Loop

Objective: complete the first playable loop.

Tasks:

1. World map with unlockable locations.
2. Location action panel.
3. Event choice resolution.
4. Reward, flag, inventory, reputation, morality changes.
5. Action point and day progression.
6. Basic battle start, attack, victory, retreat.

Acceptance:

- Player can travel, trigger events, fight, get rewards, unlock a new place, and progress days.

## Phase 3: Content System

Objective: move from hardcoded content to content packs.

Tasks:

1. Create JSON data files for actors, skills, items, world nodes, events, schools, shops, battles.
2. Add ContentLoader.
3. Add validation for broken ids.
4. Keep fallback default content for safety.

Acceptance:

- Runtime can load data from Resources JSON.
- Missing or invalid content gives clear fallback or warning.

## Phase 4: RPG Systems

Objective: add the JY3-like long-term RPG systems.

Tasks:

1. Martial art categories, levels, exp, requirements.
2. School join/rank/contribution/unlock routes.
3. Teammate recruitment and affinity.
4. Inventory and shop buy/sell.
5. Quest log and branching state.
6. Life skills: herb gathering, fishing, hunting, mining.

Acceptance:

- Player has meaningful growth choices beyond one-off events.

## Phase 5: UI Refactor and Visual Polish

Objective: turn the prototype into a polished wuxia UI.

Tasks:

1. Split GameRootView into screens and components.
2. Add reusable JianghuPanel, JianghuButton, TopStatusBar, CharacterRow, ItemSlot.
3. Improve world map visual hierarchy.
4. Add dialogue screen, battle screen, inventory screen, skill screen, school screen.
5. Improve Chinese localization.

Acceptance:

- UI feels intentionally designed and no longer like a debug prototype.

## Phase 6: Story Content Expansion

Objective: build enough original content to feel like a small playable chapter.

Tasks:

1. Opening village chain.
2. Shaolin entry chain.
3. Tavern conflict chain.
4. Hidden forest rescue chain.
5. First companion route.
6. First boss fight.
7. Chapter ending state.

Acceptance:

- A player can play 20-30 minutes of original content.

## Immediate Execution Order

1. Add task board issues.
2. Add run instructions.
3. Add project generation fallback documentation.
4. Add content loader skeleton.
5. Add quest models and quest panel.
6. Split basic reusable UI components out of GameRootView.
