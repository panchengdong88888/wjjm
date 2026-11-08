# 检查点 #15：DiuItems 草稿复核与短辅助函数首批验收

日期：2026-11-08

## 一、DiuItems 首版草稿复核结果

文件：`04_源码候选/root46_DiuItems.lua`

逐项对照 corrected disassembly PC 及 #12/#13 检查点：
- PC 2–8：防重入逻辑正确；重入调用直接 return，不清理别人的锁。
- PC 9–13：`GetDroppedItems()` 第二返回值为地面数量，false/nil 归一为 0。
- PC 14–26：严格判断 `35 < groundItemCount`，提示拼接当前数量与固定上限。
- PC 27–35：BAG_DATA 缺失时清理状态并返回。
- PC 69–114：pairs iterator 的第一返回值用于终止，第二返回值作为 item；Name/MakeIndex false/nil 跳过；ITEM_IS_BIND truthy 跳过。
- PC 89–98：R4 在 PC36 设为 1，活动路径恒真，PC91–95 matcher 调用不可达；草稿省略无活动效果的关键词构造并保留注释。
- PC 99–112：候选字段与默认值正确。
- PC 115–123：空候选提示与清理正确。
- PC 124–160：ipairs 遍历；PC129 达到上限时提示并 break；未达上限才发当前候选。
- PC 143–156：LuaSendMsg 参数顺序正确。
- PC 157–158：发送次数和本地地面数量均加 1；草稿已包含两项更新。
- PC 161–169：汇总发送次数、清除状态、返回。

复核结论：**活动路径草稿与已确认 PC 语义一致**。但关键词表/子闭包的原始构造被有意省略，且外部 helper/API 未运行时验证，所以 DiuItems 仍保留“首版普通 Lua 草稿”，不提升为完整静态恢复。

## 二、短辅助函数首批复核

文件：`04_源码候选/小型辅助函数_首批草稿.lua`

以下 6 个原型已与各自反汇编核对：
1. `root.children[13]` GetMapId：`SL:GetMetaValue("MAP_ID") or 0`。
2. `root.children[29]` IsDie：`actor and not actor:IsDie()`；保留 actor 为 false/nil 时短路返回原值。
3. `root.children[30]` GetMapName：`SL:GetMetaValue("MAP_NAME") or ""`。
4. `root.children[39]` GetMainPlayerID：`global.gamePlayerController:GetMainPlayerID()`。
5. `root.children[28].children[0]` 距离比较器：`a._distance < b._distance`。
6. `root.children[46].children[0]` 关键词 matcher：`ipairs(capturedKeywords)`，并调用 `string.find(text, keyword, 1, true)`，plain 参数确认为 true。

这 6 个短原型指令少、数据流闭合、无未解释分支，静态源码可以完整表达。状态提升为“完整静态恢复（未运行时验证）”。这不代表已在游戏环境运行。

## 三、数量与下一步

- 完整静态恢复：由 2 个增至 8 个原型（原有 2 个 + 本批 6 个）。
- 运行时验证：仍为 0。
- DiuItems：首版草稿已复核活动路径，但因保留的死分支/省略构造仍不计完整静态恢复。
- 下一步：批量寻找更多短函数/简单 helper，直接形成普通 Lua 草稿；复杂原型先恢复主体，再补疑难分支。
