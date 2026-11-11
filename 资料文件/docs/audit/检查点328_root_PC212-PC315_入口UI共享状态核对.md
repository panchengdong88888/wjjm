# 检查点328：root PC212-PC315入口、UI闭包、账号挂接与共享状态核对

日期：2026-11-11

## 核对依据
- VM原始root原型PC212-PC315。
- root.children[55] AccountIDValidation及其子原型指令已读取，用于确认父级捕获目标。
- 唯一交付源码`MainLeftBottom_唯一交付文件.lua`。

## PC212-PC279：全局入口与UI闭包

| VM PC | 指令语义 | 唯一源码对应 | 结果 |
|---|---|---|---|
| PC212-PC213 | IsInWhitelistMap无捕获并导出ENV | `rootEnvironment.IsInWhitelistMap` | 一致 |
| PC214-PC237 | MainLoop按22项顺序捕获并导出ENV.MainLoop | MainLoop闭包的22项词法引用顺序与root寄存器列表对应 | 一致 |
| PC238-PC246 | InitGatherMonsters捕获[T3,T18,T23,T13,T35,T8,T4]并导出 | 函数引用timerState、运行标记、格式化/状态/重置闭包、gatherConfig、PrintLog | 一致 |
| PC247-PC255 | StopGatherMonsters捕获[T18,T3,T25,T23,T13,T35,T4]并导出 | 函数引用同一运行标记、timerState、ClearTargetID_2等词法对象 | 一致 |
| PC256-PC258 | Builtsetting捕获T5通知闭包并导出 | `Builtsetting`使用ShowLocalNoticeByType | 一致 |
| PC259-PC260 | MoveItemToQuickUse无捕获并导出 | `rootEnvironment.MoveItemToQuickUse` | 一致 |
| PC261-PC265 | DestroyUI捕获[T0,T3,T1]，写入a.hide | 函数引用a、timerState、b并赋值`a.hide` | 一致 |
| PC266-PC269 | SetButtonVisibilityState捕获[T0,T1]，写入a.show | 函数引用a、b并赋值`a.show` | 一致 |
| PC270-PC274 | ShowHideAllButtons捕获[T3,T1,T0]，写入a.destroy | 函数引用timerState、b、a并赋值`a.destroy` | 一致 |
| PC275-PC279 | AccountIDValidation捕获[T4,T5]并写入MainLeftBottom.main | `accountPrintLog`/`accountShowLocalNotice`别名及`rootEnvironment.MainLeftBottom.main` | 一致 |

## PC280-PC296：共享常量与状态表

- PC280-PC282的`{"随机传送石"}`与`randomTeleportItemNames`一致。
- PC283-PC285的2.0、0.01、30.0三个常量与源码一致。
- PC286-PC293状态表字段按顺序为lastAttacker=nil、lastHp=nil、deathHandled=false、alertAt=0、nextTryAt=0、noStoneWarned=false、distance=nil；源码字段和值一致。
- PC294将同一blacklistState对象写入a.blacklist；后续onDamageMsg及黑名单闭包引用同一词法表，不是重新复制的表。
- PC295-PC296两个配置文件名字符串一致。

## PC297-PC315：配置闭包链

- GetWritablePath无捕获；ReadNumericConfig/PCallHelper/FileExistCheck_pcall_wrapper分别捕获GetWritablePath，符合VM父级闭包创建关系。
- AnonymousHelper_49/32绑定blacklist_distance.txt；AnonymousHelper_33/54绑定gather_monster_count.txt；源码固定文件名与PC295-PC296一致。
- PCallHelper中Nested_tostring捕获写入参数，FileExistCheck中的Nested_removeFile捕获fileUtils与resolvedPath；这些是子闭包内部捕获，不与父root寄存器映射冲突。

## AccountIDValidation逻辑初步交叉核验

- root.children[55]主原型读取SL:GetMetaValue("GAME_ID")，比较数值204208；匹配后读取UID；常量表中的9个允许账号ID均为字符串。
- children[1]遍历允许列表，对输入与列表项均执行tostring后比较；命中时PrintLog并返回true，未命中时ShowLocalNotice并返回false。源码当前Nested_ID逻辑与指令结构相符。
- children[0]等待回调检查MainProperty._ui.Panel_mini_chat，条件满足时执行SL:UnSchedule(nil)及MainLeftBottom.doInit()，随后输出等待日志；源码保留nil参数和0.5秒Schedule调用顺序。
- 以上为初步核对；AccountIDValidation主原型和两个子原型仍须形成独立逐PC审计批次，不在本批提前标为完整完成。

## 结论

root PC212-PC315父级闭包/导出/共享状态核对通过，未发现明确错配。本批未修改唯一交付源码。未执行Lua 5.1编译或目标游戏运行验证。

## 下一步

继续root PC316-PC412闭包捕获、共享cell最终状态、MainLeftBottom.doInit与模块返回；之后独立完成AccountIDValidation全部指令审查，再进入doInit_UI。