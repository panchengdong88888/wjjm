# 检查点 #140：BlacklistPlayerDetection 节流与重试路径复核

日期：2026-11-09  
原型：`root.children[47]` / legacy `root/48`  
物理指令：216；常量：35；子原型：0  
本批范围：PC142-PC213（PC174-PC192仅部分闭合）

## 已确认

1. **alertAt 节流（PC142-PC159）**
   - PC142-PC144取得 `os.time()`。
   - PC145-PC147读取 `state.alertAt` 并计算 `now - state.alertAt`。
   - PC148直接读取UPVALUE_6；PC149比较阈值与时间差。
   - 达到阈值时PC151-PC152写回 `state.alertAt = now`，PC153-PC159调用UPVALUE_7并传入格式化的“野外观测到黑名单玩家”文本。
   - 因此UPVALUE_6是直接阈值值，不是函数；旧草稿的 `(UPVALUE_6 or 0)` 可保留为假值兜底，但不能写成函数调用。

2. **nextTryAt 主门槛（PC160-PC173）**
   - 读取 `state.nextTryAt`，PC162以 `nextTryAt <= now` 为进入条件；不满足则跳到循环尾。
   - PC164-PC165读取并零参数调用UPVALUE_8。
   - PC168-PC171写入 `state.nextTryAt = now + UPVALUE_8()`。
   - PC172-PC173将 `state.noStoneWarned = false`。

3. **失败/提示路径（PC193-PC213）**
   - PC193-PC196另一条路径读取UPVALUE_11，计算 `now + UPVALUE_11` 并更新 `state.nextTryAt`。
   - PC197-PC202读取 `noStoneWarned`；仅未提示时置为true并调用UPVALUE_10，文本为“没有随机传送石，黑名单玩家传送暂停”。
   - PC206-PC213取得UPVALUE_7、调用 `table.concat(UPVALUE_12(), "/")`，再将拼接结果与“没有可用的随机传送道具（%s）”格式文本交给通知回调。
   - 由此确认UPVALUE_12()返回供table.concat使用的数组/序列；分隔符为斜杠。

## 尚未闭合

- PC174-PC192包含“黑名单玩家：%s（%d格），飞随机”提示及后续详细文本回调，但寄存器复用和捕获函数身份尚未完全闭合。
- 实际随机传送道具筛选、物品使用API、成功/失败分支的准确边界仍需继续追踪，不能把UPVALUE_9(actorName,distanceResult)臆定为道具选择函数。
- 本函数13个upvalue的父寄存器/业务身份尚未全部映射。

## 源码处理

- 已修订 `04_源码候选/短函数草稿_第五十九批.lua`：修正UPVALUE_6直接阈值、UPVALUE_8零参数间隔函数；移除未经证实的 `UPVALUE_9(actorName,distanceResult)` 道具选择调用；把未闭合的PC174-PC192保留为明确TODO。
- 同步更新函数状态CSV、机器状态JSON和防中断协议。
- 本批只校正已有草稿，不新增草稿，不升级完整静态恢复。

## 统计

- 普通Lua草稿：78
- 完整静态恢复：76 / 110
- 运行时验证：0

下一步：继续闭合PC174-PC192及随机传送道具实际使用契约；随后复核StorageItems PC151-PC224与两个子原型。


## 检查点 #145 纠错补充（2026-11-09）
此前本报告对UPVALUE_8、UPVALUE_9、UPVALUE_7、UPVALUE_10及UPVALUE_12的身份/用途有误，按PC164-PC213、父root闭包创建点和root/25辅助函数重新校正：
- PC164-PC165零参数调用的是UPVALUE_8()，不是重试间隔函数。它对应root.children[24]（legacy root/25）辅助闭包。
- 该辅助闭包遍历捕获的单项名称数组`{"随机传送石"}`，查询`SL.GetMetaValue("ITEM_INDEX_BY_NAME")`与`SL.GetMetaValue("ITEM_COUNT")`；有库存时调用`SL.UseItemByIndex`，并返回已使用道具名称；无库存则返回nil。因此随机传送物品选择与实际使用API确实存在，且本次已确认使用的是“随机传送石”。
- PC166-PC167检查UPVALUE_8()返回值。真值路径PC168-PC173执行`state.nextTryAt = now + UPVALUE_9`，UPVALUE_9是直接数值0.01，并复位`noStoneWarned=false`；假值路径进入PC193。
- PC174-PC183调用UPVALUE_10（root.children[20] / legacy root/21的本地通知包装器），格式化文本`"黑名单玩家：%s（%d格），飞随机"`的两个实参为UPVALUE_11（数值30.0）和`distanceResult or 0`。不将30.0擅自解释为玩家名。
- PC184-PC191调用UPVALUE_7（root.children[16] / legacy root/17的日志包装器），实参为格式串、actorName、`distanceResult or 0`、UPVALUE_8()返回的已使用道具名称。
- 无道具路径PC193-PC196执行`state.nextTryAt = now + UPVALUE_11`，UPVALUE_11为数值30.0；PC197-PC205按`noStoneWarned`进行一次性本地提示。
- PC206-PC213调用UPVALUE_7记录诊断。PC210的UPVALUE_12是捕获数组本身，不是函数；根函数在闭包创建前将该数组构造为`{"随机传送石"}`。正确表达式是`table.concat(UPVALUE_12, "/")`，不是`table.concat(UPVALUE_12(), "/")`。
- 由此撤销本报告中“UPVALUE_8为间隔函数”“UPVALUE_11为另一路间隔函数”“UPVALUE_7为通知回调”“UPVALUE_12()返回数组”等旧判断。UPVALUE_6仍是alertAt阈值数值（2.0），PC142-PC159调用UPVALUE_7实际是日志输出。
