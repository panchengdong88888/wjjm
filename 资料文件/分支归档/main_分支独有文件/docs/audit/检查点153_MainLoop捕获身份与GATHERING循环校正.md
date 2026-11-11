# 检查点 #153（2026-11-09）：MainLoop 捕获身份与 GATHERING 循环校正

## 本批结论

对照既有闭包捕获映射、corrected phase3 指令清单、控制流报告和相关子原型后，闭合 MainLoop 两个此前未知的捕获身份，并修正检查点152草稿中 GATHERING 分支的循环与返回行为。

## UPVALUE_15：FindMonsterInCurrViewField

- MainLoop root.children[45] 的捕获表第15槽（零基 UPVALUE_15）来自父 root 的 T[36]。
- 父 root PC210 创建 child-index 14 的闭包；该原型在指令级清单中为 FindMonsterInCurrViewField，路径 root.children[14]。
- 该辅助函数没有形式参数；它调用 SL:FindMonsterInCurrViewField(true, true)，遍历结果并以 actor:GetID() 为键、actor 对象为值构建映射表。
- MainLoop GATHERING 等待归属分支在 PC159 将 UPVALUE_12 作为额外参数传给该函数。被调函数没有读取形式参数/变参，因此该实参不影响映射构造；保留调用点实参以忠实反映 VM 调用。
- 普通扫描分支和 ATTACKING 分支均直接调用该 helper 取得 ID->actor 映射。

## UPVALUE_20：SetTargetID

- MainLoop 捕获表第20槽（零基 UPVALUE_20）来自父 root 的 T[24]。
- 父 root PC184 创建 child-index 35 的闭包；该原型为 SetTargetID，路径 root.children[35]。
- 子函数有一个显式参数 targetID。
- Facade 缺失时返回 false；PlayerInputProxy 缺失时返回 false；否则调用 proxy:SetTargetID(targetID, global.MMO.SELETE_TARGET_TYPE_FIND) 并返回 true。
- GATHERING 与 ATTACKING 中的 UPVALUE_20(targetID) 因此可在草稿中命名为 SetTargetID；不是 PickUpItems。

## PC166 / PC313：GATHERING 数值 for 循环

- PC162 读取 UPVALUE_10 到 R3，并读取 UPVALUE_8 到 R4。
- PC164 将 R4 替换为 #UPVALUE_8；PC165 将 R5 置为 1。
- PC166 的 OP_023 对 R3 做 R3 = R3 - R5 的循环准备，并跳转到 PC313。
- PC313 的 OP_412 A=3、B=166 是对应的数值循环回边：循环体从 PC167 开始，退出到 PC314，继续迭代回 PC167。因此循环索引覆盖 UPVALUE_10 .. #UPVALUE_8。
- PC167 从 UPVALUE_8[index] 取得 targetID，再从 FindMonsterInCurrViewField 返回的 actor map 中查 actor。

## R2 归属状态标志与循环后分支

- PC161 将 R2 置为 true，表示本轮尚未发现未归属目标。
- PC263 在 GetOwnerIDText 判断为 false、进入“归属未变更/未归属”分支时将 R2 置为 false。
- 其他玩家归属、自己归属、actor缺失或死亡路径不清除该标志。
- 未归属分支调用 SetTargetID(targetID)。成功路径写入等待标志 UPVALUE_12、截止时间 UPVALUE_13、目标 ID UPVALUE_16 和名称 UPVALUE_14，并输出等待日志；失败路径输出锁定失败日志。
- 成功与失败路径均汇合到 PC311，将 UPVALUE_10 更新为当前循环索引加一；两者都继续数值 for 循环，不在 SetTargetID 后立即 return。检查点152草稿原先在这两处提前 return，现已删除。
- 循环退出后 PC314 检查 R2：
  - R2 为 true 且扫描游标已超过候选列表长度时，输出“所有怪物归属已获取”，将索引复位为1并切换 ATTACKING。
  - R2 为 false 且扫描游标已超过列表长度时，输出“怪物列表处理完毕但未全部获取归属”，切回 IDLE 并调用 ResetGatherMonsterData。
  - 尚未扫描完列表时，两条路径均不执行结束状态转换，交由下一次 MainLoop 调度继续。
- UPVALUE_11 在“归属已属于自己”分支递增；PC314-PC343 的状态转换条件并不比较 UPVALUE_11 与目标数量。检查点152原稿中的该比较已删除。

## 文件与等级

- 修订 04_源码候选/root45_MainLoop.lua。
- 更新 02_基础索引/03_函数状态清单.csv 的 MainLoop 行。
- 更新 docs/handoff/05_机器可读接续状态.json。
- 本审计不升级完整静态恢复；MainLoop 全函数 CFG、尤其 PC359-PC405 ATTACKING 循环仍待逐 PC 复核。
- 未做 Lua 解释器、宿主或游戏运行时验证。

## 统计

- 普通 Lua 草稿：82（不变；本批校正既有草稿）。
- 完整静态恢复：76/110（不变）。
- 运行时验证：0（不变）。

下一步：逐 PC 复核 MainLoop PC359-PC405 的攻击循环，再检查前段状态门槛、owner 分支与所有返回路径，确认整个 417 条指令 CFG 与普通 Lua 主体一致。
