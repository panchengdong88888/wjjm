# 检查点 #135：BlacklistPlayerDetection 前置门槛校正

日期：2026-11-09

- 原型：`root.children[47]` / legacy `root/48`，216条物理指令、35常量、无子原型、无vararg。
- 源码：`04_源码候选/短函数草稿_第五十九批.lua`。

## 本次发现与修正

旧草稿在设置黑名单检测状态并调用UPVALUE_1后，直接读取HP；逐PC核对发现漏掉了PC5-PC11：
1. PC5-PC8取得并调用`SL.GetMetaValue("MAIN_ACTOR_ID")`。
2. PC9-PC10对结果进行truthy判断。
3. PC11在本机MAIN_ACTOR_ID缺失/假值时直接return。
4. 只有通过该门槛后，PC12-PC20才读取HP并执行tonumber转换。

现已在普通Lua草稿中补回：
```lua
local mainActorID = SL.GetMetaValue("MAIN_ACTOR_ID")
if not mainActorID then
    return
end
```
该局部值在可见后续主体中未见再次使用，因此不附会额外业务语义。

## 状态与待办

- 本次只校正已存在草稿，不新增草稿原型，不升级完整静态恢复。
- 仍待复核：13个UPVALUE的业务身份、HP/deathHandled各分支的精确比较极性、玩家信息helper返回值、ACTOR_MAP_X/Y参数对象、距离比较哨兵、随机传送物品筛选及通知API参数。
- 统计：普通Lua草稿78；完整静态恢复76/110；运行时验证0。
- 下一步：继续BlacklistPlayerDetection剩余PC及StorageItems主函数/两个子原型复核。
