# 检查点 #151：GetOwnerIDText / GetOwnerID 双普通 Lua 草稿恢复

日期：2026-11-09（Asia/Singapore）
对象：
- `root.children[7]`（legacy root/8，GetOwnerIDText），31条指令
- `root.children[38]`（legacy root/39，GetOwnerID），31条指令

## 依据

重新读取 `docs/audit/owner_id_helpers_阶段核验.md` 与 corrected phase3 中 root/8、root/39 两个函数的PC1-PC31。沿用此前已形成的静态真值表和 MainLoop 实际调用关系，不把两个相似函数合并或互相改名。

## 已形成的普通 Lua 草稿

1. `04_源码候选/root7_GetOwnerIDText.lua`
2. `04_源码候选/root38_GetOwnerID.lua`

两个函数均：
- 取第一个参数对象的 `GetOwnerID()` 返回值。
- ownerID 为 nil、空字符串或 -1 时返回 false。
- 其余情况调用 `type(ownerID)`；string 分支使用 `tostring(ownerID)` 并与原值比较；非 string 分支与第二个显式参数比较。

两函数的分支极性不同：

| 情况 | GetOwnerIDText | GetOwnerID |
|---|---|---|
| nil / 空字符串 / -1 | false | false |
| string | ownerID == tostring(ownerID) | ownerID ~= tostring(ownerID) |
| 非 string | ownerID == expectedOwnerID | ownerID ~= expectedOwnerID |

## 调用关系

既有审计确认 MainLoop 捕获这两个根闭包：
- upvalue[9] = root.children[38] GetOwnerID；调用参数为当前对象和比较ID，truthy/false 结果控制候选是否进入 table.insert 分支。
- upvalue[17] = root.children[7] GetOwnerIDText；调用参数为两个寄存器值，truthy/false 结果控制“归属已变更为自己”与“归属未变更或已离开视野”日志路径。

此处仅记录已有调用关系；参数的作者级命名仍是描述性占位，不把它们擅自命名为具体玩家字段。

## 状态与统计

- 两个原型由“部分静态核验”改为“首版普通Lua草稿（待静态复审/未运行时验证）”。
- 本批新增普通Lua草稿2个：总数79增至81。
- 完整静态恢复：76/110，不变。
- 运行时验证：0，不变。
- 没有把静态真值表误报为运行时验证。

## 下一步

优先继续寻找状态清单中“部分静态核验/阶段分析中、尚无独立Lua草稿”的小函数，先形成可读普通Lua版本；随后集中对 owner helper 做逐PC跳转复审和参数来源复核，再决定是否升级完整静态恢复。
