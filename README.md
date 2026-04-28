# JianghuQunxiaZhuan

SwiftUI iOS 单机武侠 RPG 原型项目。

当前版本是基于上传项目改造的 V2 JY3-style 重构版，重点包括：

- 重写主界面为 JY3 风格的世界地图、地点行动面板、事件弹层和战斗弹层。
- 保留现有 SwiftUI + SpriteKit 原型结构。
- 新增 `Content/JSON/`，把原始 `GameContent.json` 拆分为 JY3 式数据表镜像。
- 新增 `Docs/JY3_MIGRATION_PLAN.md`，记录后续系统拆分路线。

## 当前限制

这个仓库通过 ChatGPT GitHub Connector 上传。Connector 当前可稳定写入 UTF-8 文本文件；二进制 PNG 资源请从本地 zip 或原始工程同步到 `Resources/Assets.xcassets/`。

