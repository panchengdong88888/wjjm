# 检查点 #181：DeathAutoBlacklist 四项捕获与六次延迟请求闭合

日期：2026-11-10
原型：root.children[25]（legacy root/26）
函数：DeathAutoBlacklist
物理指令：47；常量：15；子原型：1；vararg_flag=0。

## 父 root 创建点与捕获身份

- root PC363创建child-index 25，捕获数为4；PC364-PC367依次捕获root T[41]、T[4]、T[55]、T[5]。
- T[41]是黑名单状态表：root PC286-PC293构造lastAttacker等字段，PC294挂到MainLeftBottom.blacklist。
- T[4]是PrintLog（root.children[16]），其函数本体已完成静态恢复。
- T[55]是FindBlacklistPlayer（root.children[51]）：首个参数为targetId，命中返回true及entry.Name，未命中返回false。
- T[5]是ShowLocalNoticeByType（root.children[20]）：接收通知文本并构造Type=10等通知表。
- 四项捕获顺序与函数内UP0-UP3访问方式一致，业务身份闭合。

## 父函数逐段控制流

- PC1-PC4：读取blacklistState.lastAttacker到局部记录，然后立即将共享字段清为nil；不把未知常量哨兵误写成普通字符串。
- PC5-PC16：记录不存在、name为false/nil或name为空字符串时，调用PrintLog输出固定跳过提示并返回。
- PC17-PC26：调用FindBlacklistPlayer(lastAttacker.id)；只消费首个返回值。truthy表示已在黑名单，调用PrintLog("凶手已在黑名单中：%s", name)后返回。
- PC27-PC30：未命中时调用PrintLog("被 %s 击杀，自动加入黑名单", name)。
- PC31-PC35：调用ShowLocalNoticeByType("自动拉黑：" .. name)。
- PC36-PC39：建立数值循环，起始0、上限5、步长1。
- PC40-PC45：取得SL:ScheduleOnce，创建子闭包，PC43捕获父R0（lastAttacker记录表）；延迟为0.5乘当前循环索引，调用ScheduleOnce(callback, delay)。
- PC46：推进循环并在当前索引仍不大于5时回到PC40；因此安排6次请求，延迟依次为0、0.5、1.0、1.5、2.0、2.5秒。
- PC47：返回；不收集调度句柄。

## 子原型 Nested_RequestAddBlacklistByName

- root.children[25].children[0] / Nested_RequestAddBlacklistByName（6条）已在此前完成静态复核。
- 父PC42创建闭包，PC43捕获当前lastAttacker记录表为UP[0]。
- 子PC1-PC2取得SL.RequestAddBlacklistByName并保留SL receiver；PC3-PC4读取UP[0].name；PC5调用SL:RequestAddBlacklistByName(name)；PC6返回。
- 捕获的是记录表，不是提前复制的name字符串；回调执行时再读取该表的name字段。

## 状态结论

父级四项捕获、lastAttacker取出后清空、黑名单查询返回值消费、日志/本地通知回调及六次ScheduleOnce延迟循环均闭合。父47条与子6条的调用关系已核对，DeathAutoBlacklist升级为完整静态恢复（未运行时验证）。

源码：04_源码候选/root25_DeathAutoBlacklist.lua
计数：普通Lua草稿73；完整静态恢复100/110；运行时验证0。
下一步：继续复核root.children[47] / BlacklistPlayerDetection（216条）尚未闭合的地图/障碍门槛与全CFG分区。
