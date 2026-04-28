# Architecture

This rewrite uses a layered SwiftUI RPG structure.

Layers:

- App: SwiftUI screens and reusable visual components.
- Core: data models, session state, and the central engine.
- Systems: isolated gameplay rules.
- Resources: data packs and future art or audio assets.

Main loop:

Map exploration -> location action -> event choice -> battle or reward -> growth -> new locations.

Current systems:

- JY3Engine: central state and command dispatcher.
- BattleSystem: battle state creation and damage formula.
- DialogueRunner: dialogue helper.
- SaveSystem: local save slots via UserDefaults.

Next refactor:

- WorldMapSystem
- EventSystem
- SchoolSystem
- SkillSystem
- InventorySystem
- ShopSystem
- LifeSkillSystem
