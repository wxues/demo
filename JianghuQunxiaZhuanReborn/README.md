# JianghuQunxiaZhuan Reborn

A SwiftUI/iOS rewrite inspired by the system structure of JY3-style single-player wuxia RPGs.

This rewrite is not a copy of JY3 source code, assets, names, plot text, or data. It borrows the architectural pattern only:

- data-driven content tables
- world map and city/location actions
- event and dialogue scripting
- school/faction routes
- martial art progression
- teammate recruitment and affinity
- turn-based battle loop
- life-skill side activities

## Structure

```text
JianghuQunxiaZhuanReborn/
├── App/
│   ├── JianghuQunxiaZhuanRebornApp.swift
│   └── GameRootView.swift
├── Core/
│   ├── JY3Models.swift
│   └── JY3Engine.swift
└── Resources/
    └── GameContent.json
```

## Current Version

This is a clean V0.1 rewrite focused on a stable, expandable game loop:

1. Map exploration
2. Location actions
3. Event choices
4. Rewards and flags
5. Party growth
6. Battle entry
7. School and reputation foundations

Next step: split the single SwiftUI screen into scene screens and add a proper dialogue tree runner.
