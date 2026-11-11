# MainLeftBottom(2).lua 功能等价 Lua 重建

本仓库用于理解 `MainLeftBottom(2).lua` 的原有功能，并重写为可读、可维护的功能等价普通 Lua。

## 新对话唯一入口

**每次新 AI 对话只需发：**

`继续 wjjm 功能等价复刻。请只按仓库根目录 AI_START_HERE.md 接续，直接完成当前下一项工作。`

AI 应先读取根目录 [AI_START_HERE.md](AI_START_HERE.md)，再仅读取 [机器接续状态](docs/handoff/05_机器可读接续状态.json) 和当前任务所需的源码片段。不要从头分析，不要全仓库扫描，不要例行读取历史审计和批次草稿。

## 分支规则

- 唯一开发分支：`work/functional-equivalent-rebuild-2026-11-11`
- 旧方案备份：`backup/pre-functional-rewrite-2026-11-11`（只读；默认不读取）
- 不直接修改 `main`。

## 资料目录

- `01_原始资料/`：原始输入资料。
- `02_基础索引/`：VM dump、原型索引、函数状态和 opcode 参考。
- `03_静态反汇编/`：物理 PC 反汇编及控制流证据。
- `04_源码候选/`：Lua 源码候选及功能等价重建代码。
- `docs/handoff/`：必要的项目接续与框架 API 资料。
- `docs/audit/`、历史批次草稿：过程性档案，不是新对话必读资料；已完成函数的重复过程资料应逐步清理。

## 已知底层规模

原始静态分析记录包含 110 个原型、5,580 条物理指令。JSON 原型路径使用零基 `root.children[n]`。静态证据用于约束行为，不代表 Lua 已通过语法或运行时验证。

详细接续约定、当前任务和读取边界统一以 [AI_START_HERE.md](AI_START_HERE.md) 为准。
