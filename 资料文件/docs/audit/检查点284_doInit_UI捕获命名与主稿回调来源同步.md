# 检查点284：doInit_UI捕获命名与主恢复稿回调来源同步

日期：2026-11-11  
工作分支：`work/functional-equivalent-rebuild-2026-11-11`  
基线：检查点283

## 一、本批定位的问题

对照集中恢复稿 `04_源码候选/MainLeftBottom_恢复源码.lua` 与已完成审阅的独立UI候选 `04_源码候选/短函数草稿_第六十三批.lua`，发现两份源码没有同步：

- 独立候选已经把 `make_doInit_UI` 的20个捕获形参改为业务可读名称。
- 独立候选的PC131-PC145快捷栏自动配置回调已经通过捕获的 `printLog`（UP[0]）输出消息。
- 集中恢复稿仍使用 `upvalue0..upvalue19`、`UPVALUE_0..UPVALUE_19`中转别名，并在快捷栏回调中调用未确认存在的全局 `PrintLog(message)`。

这会导致独立候选与主要交付文件表达不同，也让集中稿继续依赖没有证据的全局名称。

## 二、本批修改

文件：`04_源码候选/MainLeftBottom_恢复源码.lua`

1. 将集中稿的 `make_doInit_UI` 工厂主体同步为独立候选中已审阅的版本。
2. 将20个形参按已确认用途命名：`printLog`、`featureState`、`timerState`、`uiState`、`buttonMap`、`blacklistState`、配置读写回调/文件名、`schedule`、`gatherConfig`等。尚未确认的UP[17]/UP[19]分别保留中性名 `capturedValue17`、`capturedValue19`。
3. 删除重复的 `UPVALUE_0..UPVALUE_19`别名层；不改变任何捕获实参。
4. PC131-PC145快捷栏回调统一调用捕获的 `printLog(message)`，不再调用未证实的全局 `PrintLog`。
5. 删除独立候选中无意义的 `local buttonMap = buttonMap`自我遮蔽语句。
6. 将资源统计关闭回调中已过期的VM dump nil占位说明改为检查点225的已确认结论；实际 `timerState.resTimer = nil`清理语句保持不变。

## 三、捕获顺序与调用行为保护

`make_doInit_UI`仍接收20个参数，位置顺序不变，对应root PC390-PC410：

`T[4], T[2], T[3], T[0], T[1], T[41], T[48], T[7], T[8], T[50], T[49], T[5], T[44], T[42], T[51], T[43], T[47], T[11], T[12], T[9]`。

本批未修改根模块调用工厂时的20个实参及其顺序、GUI/SL方法的接收者和参数顺序、按钮组内容与坐标、定时器间隔、状态字段、事件绑定顺序、配置回调的跨函数参数顺序及其待核验异常，也未修改 `Nested_Anonymous`已确认的固定参数与nil调用行为。

## 四、静态核对

- 集中恢复稿只存在一个 `make_doInit_UI`定义块，且已与第六十三批主体同步。
- 工厂签名为20个捕获参数；原root装配调用位置未变。
- UI工厂内部不再存在 `UPVALUE_n`别名。
- 快捷栏回调使用捕获的 `printLog(message)`；工厂体内不再执行全局 `PrintLog(...)`。
- 主文件原有闭包注册、来源索引和root.children[42]函数状态未删除。

## 五、验证边界

本批为静态源码同步与文本一致性检查。当前环境没有可用的 `lua`、`luac`、`luajit`或Lua解析器，未声称Lua语法编译通过；目标游戏运行时验证仍为0。109/110原型静态恢复和72个普通Lua草稿统计均不因本次同步而增加。

## 六、下一步

继续复核 `doInit_UI`的PC1-PC419执行顺序、UI控件创建及事件回调与23个子原型的调用关系；优先同步已有证据充分的业务主体，不推断未文档化宿主代理内部行为。
