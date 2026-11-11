# 检查点 #123：FindBlacklistPlayer 捕获身份与查表控制流完整恢复

日期：2026-11-09

## 一、原型身份

- 函数：FindBlacklistPlayer
- 规范路径：`root.children[51]`
- legacy：`root/52`
- 原型索引：100
- 物理指令：35
- 常量：5（SL、_blacklistData、Name、ACTOR_MASTER_ID、GetMetaValue）
- 子原型：0
- dump vararg字段：1
- 父级闭包创建：root PC353，captures=1

## 二、唯一捕获身份已闭合

root PC353创建`root.children[51]`闭包，PC354紧随其后执行`OP_387 A=0 B=54 C=0`，因此子函数UP[0]来自父root寄存器R54。

父root PC352先将`root.children[48]`（legacy root/49）创建到R54。该函数在源码候选`04_源码候选/代理与回调短函数_第四批.lua`中标记为PCallHelper_2。它调用无捕获子函数Nested_FriendProxy（`root.children[48].children[0]` / legacy root/49/1），后者执行：

```lua
global.Facade.retrieveProxy(global.ProxyTable.FriendProxy)
```

PCallHelper_2将该调用置于pcall中：调用失败返回nil；成功时返回代理对象（假值结果归一为nil）。因此FindBlacklistPlayer的UP[0]身份是PCallHelper_2安全代理获取函数，不是玩家对象，也不是_blacklistData表本身。

## 三、参数槽与控制流

函数vararg字段为1；本体在PC8、PC21分别读取R0，未读取其他调用参数槽。源码候选保留`...`形式，并把首个值暂命名为targetId，不从dump字段推断更多固定参数。

### PC1-PC17：安全取得代理并执行原始标识查表

| PC | 反汇编行为 | 源码含义 |
|---|---|---|
| 1-2 | 读取UP[0]并以零实参调用 | PCallHelper_2() |
| 3-5 | 代理为假时跳过字段读取；代理为真时读取_blacklistData | 无代理返回false；否则取得黑名单表 |
| 6-7 | 黑名单表为假时跳转PC10 | 无_blacklistData返回false |
| 8-9 | 检查R0是否为真；真值继续，假值跳过查表并走false返回 | targetId为空/假值时返回false |
| 12-14 | 读取blacklistData[targetId]，检查是否为真 | 按传入标识直接查表；未命中进入后续分支 |
| 15-17 | 构造true并读取entry.Name，返回两个值 | 命中返回true, entry.Name |

### PC18-PC34：主控Actor ID回退查询

| PC | 反汇编行为 | 源码含义 |
|---|---|---|
| 18-22 | 取得SL.GetMetaValue，参数为"ACTOR_MASTER_ID"及R0 | SL:GetMetaValue("ACTOR_MASTER_ID", targetId) |
| 23-24 | 检查masterActorId；假值跳至false返回 | 无主控ID返回false |
| 25-26 | 比较masterActorId与targetId；相等时跳至false返回 | ID相同不重复查表 |
| 27-29 | 读取blacklistData[masterActorId]并检查真值 | 按主控ID回退查询 |
| 30-32 | 构造true，读取entry.Name，返回两个值 | 命中返回true, entry.Name |
| 33-35 | 构造false并返回；末尾PC35为return | 未命中返回false |

两个命中分支均没有对`entry.Name`再做truthy检查；源码不添加该条件。直接标识与主控Actor ID相等时，控制流明确返回false，不执行第二次表查找。

## 四、恢复源码

```lua
local function FindBlacklistPlayer(...)
    local targetId = ...

    local friendProxy = PCallHelper_2()
    if not friendProxy then
        return false
    end

    local blacklistData = friendProxy._blacklistData
    if not blacklistData then
        return false
    end

    if targetId then
        local entry = blacklistData[targetId]
        if entry then
            return true, entry.Name
        end
    else
        return false
    end

    local masterActorId = SL:GetMetaValue("ACTOR_MASTER_ID", targetId)
    if not masterActorId or masterActorId == targetId then
        return false
    end

    local masterEntry = blacklistData[masterActorId]
    if masterEntry then
        return true, masterEntry.Name
    end

    return false
end
```

## 五、修改与状态

- 修订`04_源码候选/短函数草稿_第三十批.lua`中FindBlacklistPlayer段落。
- 删除未经证实的`getPlayerFromArguments(...)`、player.Name前置判定，以及masterId与Name比较等旧草稿逻辑。
- 唯一捕获源改为精确的`PCallHelper_2`；其上游代理对象身份由Nested_FriendProxy闭合。
- 更新函数状态CSV：FindBlacklistPlayer升级为完整静态恢复。
- 更新机器接续状态与checkpoint协议。

## 六、统计

普通Lua草稿78；完整静态恢复65/110（59.1%）；运行时验证0。

本批只将FindBlacklistPlayer一个既有草稿升级为完整静态恢复；没有新增普通草稿，也没有运行时验证。
