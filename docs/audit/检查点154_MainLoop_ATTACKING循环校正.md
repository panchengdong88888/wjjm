# 检查点 #154（2026-11-09）：MainLoop ATTACKING 数值循环逐段校正

## 结论

依据 corrected phase3 指令、MainLoop 指令级清单与 CFG 节点，闭合 PC359-PC405 的攻击目标扫描循环。该批不新增草稿，只校正并补充现有 MainLoop 草稿注释。

## 循环结构

- PC349 输出“攻击中”提示。
- PC352-PC353 调用 UPVALUE_15，即 FindMonsterInCurrViewField，取得 actorID -> actor 映射表。
- PC354 将 R2 置为 true，作为本轮“尚未发现可攻击存活目标”的状态标记。
- PC355-PC359 准备数值 for 循环：起始索引 UPVALUE_10，上限 #UPVALUE_8，步长1；PC359 OP_395 准备循环，PC405 OP_412 回跳 PC360 或退出至 PC406。
- PC360-PC362 取 targetID=UPVALUE_8[index]，再从 actor map 中查找 actor。
- actor 缺失时，PC363-PC364 跳到 PC393 的统一跳过路径。
- actor 存在时，PC365-PC367 调用 UPVALUE_18（IsDie 包装器）；包装器在此调用路径 truthy 表示存活。非存活时 PC368-PC369 跳到 PC393。
- actor 存在且存活时，PC370 将 R2 清为 false；PC371-PC376 读取 GetName，名称缺失时回退“未知怪物”。
- PC377-PC390 格式化并输出“攻击怪物 %d: %s (ID: %s)”日志，然后调用 UPVALUE_20，即 SetTargetID(targetID)。该调用的布尔返回值不参与本分支后续判断；PC391 立即 return。因此每次 MainLoop 调用最多向 SetTargetID 提交一个存活目标。
- actor 缺失或死亡时，PC393-PC401 输出“怪物 %d (ID: %s) 已死亡或离开视野”日志；PC402-PC404 将 UPVALUE_10 更新为 index+1，然后由 PC405 继续循环。
- 所有索引扫描结束后到 PC406。正常耗尽路径中没有存活目标分支提前 return，因此 R2 保持 true；PC408-PC416 输出“所有目标怪物已死亡或离开视野，切换到空闲状态”，切换 IDLE 并调用 ResetGatherMonsterData。
- R2 在存活目标路径会被置 false，但该路径在 PC391 立即 return，不会继续走到 PC406。

## 草稿校正

- 修订 04_源码候选/root45_MainLoop.lua：将 ATTACKING 分支旧的“未确认单参数动作helper”注释改为已确认 SetTargetID(targetID)，并补充 PC354/359/405 循环说明。
- ATTACKING 的普通 Lua 结构与指令控制流吻合：扫描当前索引到列表末尾；缺失/死亡则递增索引；首个存活目标则记录并设置目标后返回；全部耗尽则重置 IDLE。
- 本批没有声称完整作者级源码已恢复，也没有执行 Lua 运行时/游戏验证。

## 统计

- 普通 Lua 草稿：82（不变）。
- 完整静态恢复：76/110（不变）。
- 运行时验证：0（不变）。

下一步：复核 MainLoop 前段 IDLE 构造、白名单门槛、GATHERING 等待状态和所有 return 的完整CFG路径，随后再判断是否可提升完整静态恢复等级。
