# 检查点 #61：GetPlayerMapPosition 静态恢复

日期：2026-11-09

## 本批新增

新增普通 Lua 源码候选：
- 文件：`04_源码候选/短函数草稿_第三十七批.lua`
- 函数：`GetPlayerMapPosition`
- 原型索引：89
- 规范路径：`root.children[44]`
- legacy 路径：`root/45`
- 物理指令：17
- 常量：5
- 子原型：0
- vararg_flag：1

## 恢复逻辑

依据 corrected phase3 反汇编逐条还原：

1. PC1–4：检查参数 actor；假值直接返回一个 nil 值。
2. PC5–8：读取 `actor.mCurrMapX`；若结果为假值，则设置为数值0。
3. PC9–12：读取 `actor.mCurrMapY`；若结果为假值，则设置为数值0。
4. PC13–16：创建结果表，写入 `x` 与 `y` 字段并返回。
5. PC17：额外 return 尾部，不改变前述可达返回语义。

条件分支使用 Lua truthiness，因此恢复代码使用 `if not value`，没有擅自缩窄成 `if value == nil`。

## 复核结论

该函数没有子原型、外部调用、循环或复杂闭包。两条坐标分支和返回表字段均能从反汇编直接确定，故升级为“完整静态恢复（未运行时验证）”。

本结论仅指静态指令/控制流恢复完成；尚未在原始 Lua VM 宿主环境运行，不宣称运行时验证。

## 统计

- 普通 Lua 草稿：47→48
- 完整静态恢复：27→28/110（25.5%）
- 运行时验证：0
- 最新检查点：#61

## 下一步

转向仍未开始的短函数，优先评估 `root.children[0]`（FileExistCheck_pcall_wrapper，32条）或 `root.children[6]`（InstallDamageHook，40条）；如闭包捕获参数关系复杂，先完成主体草稿并保留槽位注释。
