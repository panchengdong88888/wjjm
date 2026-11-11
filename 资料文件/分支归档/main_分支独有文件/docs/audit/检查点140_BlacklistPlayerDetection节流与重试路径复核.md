# 检查点 #140（经#145修订）：BlacklistPlayerDetection 节流、重试与随机传送路径

日期：2026-11-09  
原型：`root.children[47]` / legacy `root/48`  
物理指令：216；常量：35；子原型：0

> 本报告原始版本的部分UPVALUE归属在检查点#145被纠正。以下内容为统一后的权威结论，不再保留旧错误判断。

## 1. alertAt 节流（PC142-PC159）

- PC142-PC144取得`os.time()`。
- PC145-PC147读取`state.alertAt`并计算`now-state.alertAt`。
- PC148读取UPVALUE_6；父root捕获值为数值2.0，不是函数。
- 达到阈值后PC151-PC152写回`state.alertAt=now`。
- PC153-PC159通过UPVALUE_7输出格式化文本“野外观测到黑名单玩家：%s（%d格）”。UPVALUE_7是日志包装器root.children[16]（legacy root/17），不是本地通知回调。
- 该日志格式的两个实参为UPVALUE_11（数值30.0）和距离值（假值回退0）；30.0的%s业务意图尚未确认。

## 2. 尝试门槛与真实随机传送（PC160-PC192）

- PC160-PC163读取`state.nextTryAt`，仅当`nextTryAt<=now`才进入尝试路径。
- PC164-PC165零参数调用UPVALUE_8()。它不是时间间隔函数，而是root.children[24]（legacy root/25）随机传送辅助闭包。
- 该辅助闭包遍历捕获数组`{"随机传送石"}`，通过`SL.GetMetaValue("ITEM_INDEX_BY_NAME")`查询物品索引，通过`SL.GetMetaValue("ITEM_COUNT")`查询库存；库存大于0且索引有效时调用`SL.UseItemByIndex`实际使用物品，并返回物品名称；无可用库存时返回nil。
- PC166-PC167检查UPVALUE_8()结果。假值进入PC193失败路径；真值进入成功路径。
- PC168-PC173执行`state.nextTryAt=now+UPVALUE_9`，UPVALUE_9是直接数值0.01；并将`state.noStoneWarned=false`。
- PC174-PC183通过UPVALUE_10显示本地通知。UPVALUE_10对应root.children[20]（legacy root/21），内部调用`SL.ShowLocalNoticeByType`。通知模板为`"黑名单玩家：%s（%d格），飞随机"`，实参依次是UPVALUE_11（数值30.0）和`distanceResult or 0`。
- PC184-PC191通过UPVALUE_7日志包装器输出详细记录，实参依次为格式串、actorName、`distanceResult or 0`、UPVALUE_8()返回的已使用道具名称。
- PC192跳到循环尾。

## 3. 无可用道具失败路径（PC193-PC213）

- PC193-PC196执行`state.nextTryAt=now+UPVALUE_11`；UPVALUE_11为直接数值30.0，作为失败后的重试延迟。
- PC197-PC205读取`state.noStoneWarned`。仅当尚未提示时置为true，并通过UPVALUE_10显示“没有随机传送石，黑名单玩家传送暂停”；已提示则不重复显示。
- PC206-PC213通过UPVALUE_7记录“没有可用的随机传送道具（%s）”诊断。
- PC210读取UPVALUE_12本身；它是捕获数组`{"随机传送石"}`，不是函数。PC212执行`table.concat(UPVALUE_12, "/")`。

## 4. 已确认的相关upvalue身份

| 槽位 | 捕获值/业务身份 | 证据 |
|---|---|---|
| UPVALUE_6 | 数值2.0，alertAt阈值 | 父root捕获R38；PC148-PC149 |
| UPVALUE_7 | 日志包装器root.children[16] | 父root捕获R4；PC153-PC159、PC184-PC191、PC206-PC213 |
| UPVALUE_8 | 随机传送辅助闭包root.children[24] | 父root捕获R56；root/25逐条调用ITEM_INDEX_BY_NAME、ITEM_COUNT、SL.UseItemByIndex |
| UPVALUE_9 | 数值0.01，成功后的短重试间隔 | 父root捕获R39；PC168-PC171 |
| UPVALUE_10 | 本地通知包装器root.children[20] | 父root捕获R5；root/21调用ShowLocalNoticeByType |
| UPVALUE_11 | 数值30.0，失败重试延迟；同时作为成功提示格式实参 | 父root捕获R40；PC178、PC193-PC196 |
| UPVALUE_12 | 道具名称数组`{"随机传送石"}` | 父root捕获R37；root PC280-PC282构造，PC210-PC212 concat |

其余前置upvalue（UPVALUE_0至UPVALUE_5）仍需逐一映射业务身份。

## 5. 状态与待办

PC174-PC192的提示文本、通知/日志回调、格式化实参及真实随机传送物品使用API已闭合。函数仍保持“首版普通Lua草稿（待静态复审/未运行时验证）”，原因是其他upvalue身份尚未全部核清，且UPVALUE_11=30.0在成功提示中作为%s实参的业务意图未明。

普通Lua草稿：78  
完整静态恢复：76 / 110  
运行时验证：0

下一步：继续核对UPVALUE_1、UPVALUE_3、UPVALUE_4、UPVALUE_5及父闭包调用关系；不得仅凭常量30.0猜测成功通知中的%s含义。
