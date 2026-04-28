# JY3 Style Migration Plan

This project has been refactored toward a JY3-like structure.

## Completed in V2

- Reworked the root SwiftUI screen into a map-first Jianghu layout.
- Added top status bar, world map layer, location action panel, bottom navigation, event overlay, and battle overlay.
- Added split content mirror files under Content/JSON while keeping Resources/GameContent.json as the runtime source.

## Next steps

1. Split the large GameEngine into systems: WorldMap, Dialogue, Event, Battle, Quest, School, Skill, Inventory, Teammate, LifeSkill.
2. Move UI into scene-oriented screens: WorldMapScreen, CityMapScreen, DialogueScreen, BattleScreen, SkillScreen, EquipScreen, ShopScreen, TeammateScreen.
3. Replace linear event steps with dialogue trees and action lists.
4. Add school routes, martial art progression, teammate recruitment, and city/location actions.
5. Convert ContentLoader to merge multi-file JSON packs.
