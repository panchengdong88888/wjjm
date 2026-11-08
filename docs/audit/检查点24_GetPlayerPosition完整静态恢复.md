# 检查点 #24：GetPlayerPosition 完整静态恢复

日期：2026-11-09  
原型：`root.children[18]` / legacy `root/19` / `GetPlayerPosition`  
物理指令：19；常量：7；子原型：0

## 结论

该函数已达到**完整静态恢复**，尚未进行目标运行时验证。

等价普通 Lua：

```lua
local function GetPlayerPosition()
    local x = SL:GetMetaValue("X") or 0
    local y = SL:GetMetaValue("Y") or 0
    return { x = x, y = y }
end
```

## 指令依据

- PC1-4：读取全局 `SL`，取得 `GetMetaValue`，以 `"X"` 调用并将首个返回值放入 R0。
- PC5-7：检查 X 的 truthy 状态；false/nil 路径将 R0 设为数值 0，truthy 路径保留原值。
- PC8-11：以同样方式调用 `SL:GetMetaValue("Y")`，首个返回值放入 R1。
- PC12-14：检查 Y；false/nil 路径经融合指令将 R1 置为 0，并构造后续表赋值所需的中间值。
- PC15-17：创建结果表，依次写入 `x=R0`、`y=R1`。
- PC18：返回结果表；PC19 为尾部 return。

## 边界

- 这里的 `or 0` 是 Lua truthiness fallback：false 和 nil 会回退，数值 0 本身保持为 0。
- 返回的是单个坐标表，不是两个独立返回值。
- 本结论来自静态 VM 指令和融合载荷重建；未在原目标环境执行验证。
- 同文件中的 `root.children[57]` / `PlayerPos` 是另一个独立原型，不应与本函数混为一谈。

## 检查点统计

本次将完整静态恢复数从 17 更新为 18；运行时验证仍为 0。InitGatherMonsters 与 PCallHelper 仍保持草稿状态，不因本次修正而升级。
