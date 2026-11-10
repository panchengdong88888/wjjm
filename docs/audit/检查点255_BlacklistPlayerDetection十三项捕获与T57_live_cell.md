# 检查点255：BlacklistPlayerDetection十三项捕获与T57 live-cell

日期：2026-11-10

## 13项捕获顺序

依据root PC368捕获描述及root_pc341_pc412_ledger：

| UP槽 | 父寄存器 | 值/身份 | 装配值 |
|---:|---:|---|---|
| 0 | T[2] | MainLeftBottom.z 状态表 | rootModule.z |
| 1 | T[57] | InstallDamageHook闭包（PC360写入，PC368捕获时仍为该值） | rootPrototypes.InstallDamageHook |
| 2 | T[41] | blacklistState | rootSource.blacklistState |
| 3 | T[58] | DeathAutoBlacklist | rootPrototypes.DeathAutoBlacklist |
| 4 | T[55] | FindBlacklistPlayer | rootPrototypes.FindBlacklistPlayer |
| 5 | T[53] | GetMapData2DPtr | rootPrototypes.GetMapData2DPtr |
| 6 | T[38] | 2.0 | rootSource.blacklistAlertThreshold |
| 7 | T[4] | PrintLog | rootPrototypes.PrintLog |
| 8 | T[56] | UseItemByIndex | rootPrototypes.UseItemByIndex |
| 9 | T[39] | 0.01 | rootSource.blacklistShortRetryDelay |
| 10 | T[5] | ShowLocalNoticeByType | rootPrototypes.ShowLocalNoticeByType |
| 11 | T[40] | 30.0 | rootSource.blacklistNoItemRetryDelay |
| 12 | T[37] | randomTeleportItemNames | rootSource.randomTeleportItemNames |

## T[57]覆盖生命周期纠错

- PC357-PC359创建onDamageMsg并将其写入MainLeftBottom.onDamageMsg。
- PC360-PC362随后创建InstallDamageHook，并写入/覆盖父帧T[57]。
- PC368创建BlacklistPlayerDetection，PC370以OP_387捕获T[57] live cell。
- 因此UP[1]是InstallDamageHook，不是onDamageMsg。两者在根模块中承担不同角色，不能互换。
- register_value_timeline显示PC360之后、PC368捕获前及捕获后均无T[57]再次写入；因此恢复装配可直接传入当时的函数值`rootPrototypes.InstallDamageHook`，与该live cell在本模块执行路径上的可观察值一致。不要传入普通`{value=...}`表，因为候选工厂内部按函数调用UP[1]()，该表不可调用；也不需要额外制造可调用代理。

## 共享对象核对

- UP[0]接收rootModule.z，即MainLeftBottom.z状态表；T[2]在PC33被新表覆盖，PC368捕获时并非整个MainLeftBottom模块表。
- UP[2]接收rootSource.blacklistState，与MainLeftBottom.blacklist、onDamageMsg、DeathAutoBlacklist及ClearBlacklistItems共享同一表对象。
- UP[3..12]分别复用前序已静态实例化的工厂、直接绑定函数、配置数值和原始捕获表。
- 该工厂不在此处创建新的blacklistState副本，也不重新构造随机传送物品名称数组。

## 计数与限制

- 无捕获直接子原型：22/22。
- 有捕获工厂：35/36，剩余doInit_UI。
- 完整静态恢复：109（不变）。
- 普通Lua草稿：72（不变）。
- 运行时验证：0。
- 未执行目标Lua宿主或游戏运行验证。

## 下一步

检查点256只剩root.children[42] doInit_UI，20项捕获及23个子原型；先逐项核对捕获生产者和已恢复依赖，再处理未知槽位。
