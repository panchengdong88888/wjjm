# 11.16 root/79 forgeZodiac 恢复工作记录

更新时间：2026-11-20

## 当前目标

- 原型：`root/79`
- 候选真实函数名：`forgeZodiac`（由本版常量、root/10调度关系和调用结构支持）
- 参数：0
- 常量：48
- 物理指令：212
- 当前状态：部分控制流已还原；尚未写入唯一交付 Lua；不计入完整/部分恢复数量。

## 已确认的上下文关系

`root/10` 已恢复为 `startForgeZodiac`。它创建：

```lua
state.forgeZodiac = {
    checkGold = checkGold,
    ticks = 0,
    index = 1,
}
state.forgeZodiacRunning = true
state.forgeZodiacTimer = helper_root_78("蛇·[普通]", 0.1)
```

其中 `state` 为 `MainLeftBottom.z`。因此 root/79 开头读取 `H[0].forgeZodiac` 与启动函数创建的状态对象相吻合。root/79 是这个状态机的定时回调，不是独立的玩家按钮入口。

## 已闭合的指令段

### 1. 入口与计时（slot 1–10）

- slot 1–2：读取 `H[0].forgeZodiac`，即锻造状态对象。
- slot 3–5：状态对象不存在时直接结束；存在则继续。
- slot 6–8：读取并递增 `state.ticks`，再写回。
- slot 9–10：调用全局 `GetMapName()`，取得当前地图名。

### 2. 金币检查状态（slot 11–21）

- slot 11–13：读取 `state.state`，与 `"checkGold"` 比较；非此状态跳过金币检查段。
- slot 14–15：读取闭包捕获的金币检查函数并调用，返回金币数量。
- slot 16–21：与常量 2,500,000 比较；不足时调用捕获的提示函数显示“金币不足250W，停止锻造”，然后结束本轮回调。达到门槛时跳过不足提示并进入传送流程。

### 3. 发起前往神龍之都（slot 22–36）

- slot 22：设置 `state.state = "toShenlong"`。
- slot 23：重置 `state.ticks = 0`。
- slot 24–32：组装并调用 `LuaSendMsg`，消息参数包含 9002、80101、"神龍之都"、12 等常量。
- slot 33–35：调用捕获的提示回调，显示“前往神龍之都锻造生肖”。
- slot 36：结束本轮回调。

### 4. 地图确认与NPC移动（slot 37–96）

- slot 37–39：仅当 `state.state == "toShenlong"` 时进入地图确认段。
- slot 40–47：使用 `string.find` 检查当前地图名是否包含“神龍之都”。
- slot 49–50：地图匹配后将状态切换为 `"walkNpc"` 并重置 ticks。
- slot 52–64：未到目标地图时进行计时与重发地图请求的分支。
- slot 66–96：`"walkNpc"` 状态下调用 `MoveTo`，并准备通过 `LuaSendMsg` 发送NPC交互消息；随后切换为 `"clickNpc"` 并重置 ticks。

说明：slot 66–96 的坐标/目标NPC捕获值、消息字段和条件跳转尚未全部闭合，当前只记录已由指令调用形状支持的职责，不将猜测的坐标、NPC编号或消息类型写入最终函数。

## 后续必须完成的段落

1. slot 97–111：`clickNpc` 状态等待条件、切换到 `forge` 状态及提示。
2. slot 112–158：遍历背包生肖装备，检查装备名称，按 `Index` 调用 `SL.UseItemByIndex`，恢复成功提示及控制流。
3. slot 159–190：`forgeNextTick` 计时、30 tick间隔、`tryCount` 累加及200次上限。
4. slot 191–212：组装锻造进度提示文本；确认该段是否所有路径均可达。
5. 补齐 root/79 的父级闭包捕获映射，避免把 H[n] 猜成错误业务对象。
6. 全部212条指令与融合消费槽位、跳转目标闭合后，再写入 `MainLeftBottom_11.16_明文.lua`，并同步CSV与总账。

## 重要边界

- 不分析官方开发文档API的内部实现；只按调用点和现有开发文档名称使用。
- 不把11.2旧版主体直接复制到11.16。
- 不以常量字符串代替控制流证据。
- 本记录只表示阶段性控制流分析，不能将 root/79 标为“已恢复”。
