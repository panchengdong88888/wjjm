# 检查点 #27：InitGatherMonsters 完整静态恢复

日期：2026-11-09  
原型：`root.children[19]` / legacy `root/20` / `InitGatherMonsters`  
物理指令：36；常量：11；子原型：1（MainLoop wrapper，3条指令）

## 七个捕获值的身份已闭合

根初始化函数 PC238 创建该闭包，捕获数为 7；PC239–245 依次捕获：

| UP | 根级来源 | 已确认身份 |
|---|---|---|
| UP[0] | T[3] | 运行状态表，包含 `gatherTimer` |
| UP[1] | T[18] | 被置为 true 的引怪运行标志 |
| UP[2] | T[23] | `FormatStateChange` 闭包 |
| UP[3] | T[13] | 状态常量表，含 IDLE/GATHERING/ATTACKING |
| UP[4] | T[35] | `ResetGatherMonsterData` 闭包 |
| UP[5] | T[8] | 配置表，含 CHECK_INTERVAL/GATHER_THRESHOLD |
| UP[6] | T[4] | 启动通知回调 |

身份闭合依据：
- 根 PC181 创建 `root.children[8]`，原型索引明确标记为 `FormatStateChange`，随后 PC182–183 捕获 T[4]、T[14]，闭包赋给 T[23]。
- 根 PC168–171 创建 T[13] 状态表，并写入 IDLE/GATHERING/ATTACKING 三个字段。
- 根 PC200 创建 `root.children[26]`，原型总索引将其标记为 `ResetGatherMonsterData`，闭包赋给 T[35]。
- 根 PC238–245 将上述值按顺序捕获到 InitGatherMonsters。

## 36 条指令还原

1. PC1–11：读取旧 `runtimeState.gatherTimer`；若存在，执行 `SL:UnSchedule(timer)`，再清空字段。
2. PC12–13：将捕获的引怪运行标志设为 true。
3. PC14–17：调用 `FormatStateChange(stateConstants.IDLE)`。
4. PC18–19：无参数调用 `ResetGatherMonsterData()`。
5. PC20–27：通过 `SL:Schedule(MainLoop, config.CHECK_INTERVAL)` 创建定时任务，并把返回值保存到 `runtimeState.gatherTimer`。
6. PC28–35：格式化启动提示，使用 `config.GATHER_THRESHOLD`，调用通知回调。

特别校正：Schedule 与 UnSchedule 的调用均保留 SL 作为方法接收者，即使用冒号调用形式，而不是丢失 self 的点调用形式。

## 等价普通 Lua

```lua
local function InitGatherMonsters()
    if runtimeState.gatherTimer then
        SL:UnSchedule(runtimeState.gatherTimer)
        runtimeState.gatherTimer = nil
    end

    isGathering = true
    FormatStateChange(stateConstants.IDLE)
    ResetGatherMonsterData()

    runtimeState.gatherTimer = SL:Schedule(
        MainLoop,
        config.CHECK_INTERVAL
    )

    showNotice(string.format(
        "引怪功能已启动 (阈值: %d)",
        config.GATHER_THRESHOLD
    ))
end
```

## 状态

该原型升级为**完整静态恢复**。尚未在目标运行时执行验证。
完整静态恢复总数由 22 增至 23；运行时验证仍为 0。
