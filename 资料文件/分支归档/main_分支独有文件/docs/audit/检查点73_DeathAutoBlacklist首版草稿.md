# 检查点 #73：DeathAutoBlacklist 首版普通 Lua 草稿

日期：2026-11-09

## 原型身份
- 原型索引：33
- 规范路径：`root.children[25]`
- legacy：`root/26`
- 47条物理指令、15个常量、1个子原型、`vararg_flag=0`。

## 创建点与捕获
根函数PC363创建本闭包，captures=4；紧随其后的捕获记录依次为：
- child UPVALUE_0 <- root R41
- child UPVALUE_1 <- root R4
- child UPVALUE_2 <- root R55
- child UPVALUE_3 <- root R5

四个寄存器的业务身份尚未从根函数注册/赋值链全部追踪，源码保留UPVALUE槽位，不臆造原作者变量名。

## 主体控制流
- PC1-PC4：从UPVALUE_0读取`lastAttacker`，并立即将该字段写为nil。
- PC5-PC16：攻击者对象缺失、`name`缺失或为空时，调用UPVALUE_1显示“本次死亡没记录到凶手，跳过自动拉黑”，随后返回。
- PC17-PC21：调用UPVALUE_2(attacker.id)。返回真值时跳至已在黑名单分支。
- PC22-PC26：已在黑名单时，调用UPVALUE_1显示格式化文本“凶手已在黑名单中：%s”，随后返回。
- PC27-PC30：未命中时，调用UPVALUE_1显示“被 %s 击杀，自动加入黑名单”。
- PC31-PC35：调用UPVALUE_3，参数为“自动拉黑：”与攻击者name的拼接结果。
- PC36-PC39：数值for循环预处理，循环初值0、上限5、步长1；循环变量对应PC44使用的R4。
- PC40-PC45：取得`SL.ScheduleOnce`，创建子回调；每轮将回调与`0.5 * 循环变量`传入ScheduleOnce。
- PC46：循环步进并回跳PC40，故总计六次调度，延迟依次为0、0.5、1、1.5、2、2.5秒。
- 子原型`root/26/1`共6条指令，捕获父函数R0；父R0为攻击者对象。回调调用`SL.RequestAddBlacklistByName(attacker.name)`。

## 草稿边界
- 已恢复主要分支、提示文本、字段访问、黑名单查询调用、调度次数/间隔及子回调。
- UPVALUE_1、UPVALUE_2、UPVALUE_3的业务名称仍未完全闭合；仅保留槽位名。
- `ScheduleOnce`和`RequestAddBlacklistByName`的外部运行时行为未在宿主环境验证。
- 本批只计首版普通Lua草稿，不升级完整静态恢复；运行时验证数保持0。
