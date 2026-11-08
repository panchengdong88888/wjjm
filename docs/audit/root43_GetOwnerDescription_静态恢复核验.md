# root.children[43] / GetOwnerDescription：特殊常量与完整静态恢复核验

日期：2026-11-08
状态：**完整静态恢复（尚未运行时验证）**
原型：`root.children[43]`（旧标签 `root/44`）
物理指令：20；常量：7；子原型：0

## 1. 特殊常量结论

VM dump 中出现的 `["unknown", 2]` 不能当成 Lua 字符串 `"unknown"`，也不能当成普通业务数组。

交叉证据：
- 整份 VM dump 中该数组形态常量出现 23 次，分布于 20 个原型。
- 根原型将其用于 `hidebut`、`lastAttacker`、`lastHp` 等状态字段的初始值。
- 多个函数将同一标记写入 `gatherTimer`、`resTimer`、`rewardTimer`、`storageTimer`、`takeTimer`、`dropTimer` 等“无定时器句柄”字段。
- 清理/重置类指令也将该标记写入状态槽。
- 这些位置的业务语义均对应 Lua 的 `nil`，因此该结构是当前 VM dump 对 nil 的序列化占位表示。不能在恢复后的 Lua 中写成字符串 `"unknown"`。

该结论是基于跨原型的常量使用方式作出的静态语义判定；没有把它误称为运行时测试结果。

## 2. root.children[43] 指令语义

原型常量：
- `K[0] = -1`
- `K[1] = "其他玩家"`
- `K[2] = "GetOwnerID"`
- `K[3] = "无归属"`
- `K[4] = ""`
- `K[5] = ["unknown", 2]`（nil 序列化标记）
- `K[6] = "自己"`

控制流逐条对应：
1. PC 1–2：对第一个参数调用 `actor:GetOwnerID()`，结果放入 R2。
2. PC 4–5：ownerID 等于 nil 标记时跳到“无归属”分支。
3. PC 6–7：ownerID 等于空字符串时跳到“无归属”分支。
4. PC 8–9：ownerID 等于 -1 时跳到“无归属”分支。
5. PC 12–15：否则将 ownerID 与第二个参数比较；相等时 description 为“自己”。
6. PC 16：不相等时 description 为“其他玩家”。
7. PC 17–19：把 R2（ownerID）复制到 R4，把 R3（description）复制到 R5，按 R4..R5 顺序返回。

## 3. 调用点交叉核验

调用方是 `root.children[45]`（旧标签 `root/46`，MainLoop）：
- MainLoop PC 24–25 调用捕获的 GetMainPlayerID 辅助函数，结果保存在 R0。
- 从 PC 25 到 PC 210，R0 没有被覆盖为其他业务值；中间出现的 A=0 指令是条件跳转/比较/return。
- MainLoop PC 208 读取 upvalue[19]，闭包映射确认它是本函数。
- PC 209 将 R8（当前 actor）作为第一个参数。
- PC 210 将 R0（mainPlayerID）作为第二个参数。
- PC 211 调用函数并接收两个返回值 R10、R11。
- PC 228/230 分别读取 R10、R11，PC 231 将它们送入“归属ID: %s, %s”日志格式，验证返回顺序为 ownerID、description。

因此参数映射与返回顺序已由调用点确认，不再使用旧报告中“description, ownerID”的错误顺序。

## 4. 作者级 Lua 恢复

```lua
local function GetOwnerDescription(actor, mainPlayerID)
    local ownerID = actor:GetOwnerID()
    local description

    if ownerID == nil or ownerID == "" or ownerID == -1 then
        description = "无归属"
    elseif ownerID == mainPlayerID then
        description = "自己"
    else
        description = "其他玩家"
    end

    return ownerID, description
end
```

对应源码文件：`04_源码候选/root43_GetOwnerDescription.lua`
辅助函数总表：`04_源码候选/verified_helpers_batches_1_3.lua`

## 5. 验收边界

- 20 条物理指令均已映射到上述普通 Lua 控制流。
- 参数含义经 MainLoop 调用点确认。
- 两个返回值的顺序经调用方日志参数确认。
- nil 标记经跨原型初始化/清理用途交叉确认。
- **未执行游戏运行时验证**，不得标记为运行时完成。
