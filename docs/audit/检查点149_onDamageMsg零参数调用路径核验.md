# 检查点 #149：onDamageMsg 零参数调用路径核验

日期：2026-11-09（Asia/Singapore）
调用方：`root.children[47]` / BlacklistPlayerDetection
被调用闭包：`root.children[53]`（legacy root/54），72条指令、1个子原型、vararg标记2

## 调用点

BlacklistPlayerDetection PC1-PC4：
- 从 UP[0] 取主模块状态表并写入 `isBlacklisting=true`。
- 从 UP[1] 取回调闭包并以零个显式参数调用。

检查点146已确认 UP[1] 对应 root.children[53]，并挂在黑名单状态表的 onDamageMsg 字段。

## 被调用函数入口

root/53 PC1-PC5：
- PC1 对第二个形式参数 R1 做 truthiness 检查。
- 当 R1 为 nil/false 时，控制流经 PC2 跳转至 PC5 return。
- 当 R1 truthy 时才继续检查 PC3 的空字符串条件，随后进入 pcall 和子原型处理路径。

由于调用点 PC4 没有传入任何显式参数，第二个形式参数 R1 在该调用中为 nil，因此必定走 PC1-PC5 的提前返回路径；PC6之后的 pcall、ACTOR_IS_HERO、攻击者/主人ID、名称和 lastAttacker 写入逻辑均不会由这次零参调用触发。

## 草稿修正

已更新 `04_源码候选/root47_BlacklistPlayerDetection.lua`：
- 保留源字节码中的 `onDamageMsg()` 调用。
- 注释明确指出该零参调用落入 root/53 的入口提前返回分支，不把它描述为刷新伤害消息状态。
- 不删除调用，不推断其无关场景下的功能；只限定本调用点可证明的效果。

## 状态

- 这是调用点/被调用函数入口的静态路径确认。
- 不增加普通Lua草稿数量。
- 不增加完整静态恢复数量。
- 未做宿主运行时验证。

统计保持：普通Lua草稿78、完整静态恢复76/110、运行时验证0。

## 下一步

root/47 剩余待核验项为 root/23 距离函数的地图边界/障碍校验、全216条指令CFG独立复核。按新策略，不让这些少量疑点阻塞其他尚无草稿的短函数批量恢复。
