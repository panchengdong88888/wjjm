# 检查点 #145：BlacklistPlayerDetection 随机传送真实调用链与PC174-PC192闭合

日期：2026-11-09  
原型：`root.children[47]` / legacy `root/48`  
范围：PC160-PC213，重点PC164-PC192

## 1. UPVALUE_8()不是间隔函数，而是真实随机传送道具使用辅助闭包

父root PC355创建`root.children[24]`（legacy `root/25`）闭包，捕获root R37。父root PC280-PC282将R37构造成单项数组`{"随机传送石"}`；PC381将该数组作为BlacklistPlayerDetection的UPVALUE_12捕获。root/25闭包自身也捕获该列表。

root/25逐项执行：
1. `ipairs(UPVALUE_0)`遍历道具名称。
2. 通过`SL.GetMetaValue("ITEM_INDEX_BY_NAME")`取得名称到索引的查询能力。
3. 通过`SL.GetMetaValue("ITEM_COUNT")`取得库存数量查询能力。
4. 对当前名称查询索引和库存数量。
5. 库存数量大于0且索引有效时，调用`SL.UseItemByIndex`实际使用该物品。
6. 返回当前道具名称；遍历完仍无可用道具则无显式返回值（nil）。

因此父函数PC164-PC165的`UPVALUE_8()`会真实尝试使用“随机传送石”，不是一个重试间隔函数，也不是单纯检测函数。

## 2. 成功路径PC166-PC192

- PC166-PC167检查UPVALUE_8()返回值；假值跳转PC193失败路径。
- PC168-PC171：`state.nextTryAt = now + UPVALUE_9`。UPVALUE_9是直接数值0.01，不是函数。
- PC172-PC173：`state.noStoneWarned = false`。
- PC174-PC183：UPVALUE_10是root.children[20]（legacy root/21）本地通知包装器。通知文本由`string.format("黑名单玩家：%s（%d格），飞随机", UPVALUE_11, distanceResult or 0)`构造。UPVALUE_11的实际捕获值为数值30.0；保留该真实实参，不猜测其在此处作为%s的业务意图。
- PC184-PC191：UPVALUE_7是root.children[16]（legacy root/17）日志包装器。调用实参依次为格式串、actorName、distanceResult或0、UPVALUE_8()返回的已使用道具名称。
- PC192跳到函数循环尾。

## 3. 失败路径PC193-PC213

- PC193-PC196：`state.nextTryAt = now + UPVALUE_11`，UPVALUE_11为数值30.0。
- PC197-PC205：若`state.noStoneWarned`尚未置位，则设为true，并通过UPVALUE_10显示“没有随机传送石，黑名单玩家传送暂停”；已提示则跳过重复通知。
- PC206-PC213：通过UPVALUE_7记录格式串“没有可用的随机传送道具（%s）”及道具列表文本。PC210读取UPVALUE_12本身（不是函数调用），PC212执行`table.concat(UPVALUE_12, "/")`。捕获数组内容为`{"随机传送石"}`。

## 4. 检查点140旧结论纠正

撤销以下错误描述：
- “UPVALUE_8为零参数间隔函数”——实际是随机传送道具选择并使用闭包。
- “UPVALUE_11为另一条间隔函数”——实际是数值30.0；失败路径用作重试延迟。
- “UPVALUE_7为通知回调”——实际为日志包装器；本地通知由UPVALUE_10执行。
- “table.concat(UPVALUE_12(), "/")”——正确为`table.concat(UPVALUE_12, "/")`，UPVALUE_12是列表。
- PC142-PC159的UPVALUE_7调用是日志输出，不是本地通知。

## 5. 状态

PC174-PC192的格式化文本、回调身份和真实道具使用路径已闭合。仍有其他upvalue（如UPVALUE_1、UPVALUE_3、UPVALUE_4、UPVALUE_5）业务身份待逐一核对，且UPVALUE_11=30.0在成功通知格式中被用作%s的意图未明，因此函数不升级完整静态恢复。

普通Lua草稿：78  
完整静态恢复：76 / 110  
运行时验证：0
