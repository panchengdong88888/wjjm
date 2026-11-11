# 检查点330：AccountIDValidation主原型及两个子原型逐段核对

日期：2026-11-11

## 证据
- VM：root.children[55] AccountIDValidation，主原型60条指令，直接子原型2个。
- 子原型0：等待主界面属性栏初始化回调。
- 子原型1：账号ID白名单匹配闭包。
- 唯一源码：`MainLeftBottom_唯一交付文件.lua`第1601-1657行。

## 主原型（60条指令）

| VM PC范围 | 指令语义 | 源码对应 | 结果 |
|---|---|---|---|
| PC1-PC4 | 取SL并调用GetMetaValue("GAME_ID") | `SL:GetMetaValue("GAME_ID")` | 一致 |
| PC5-PC8 | 拼接“游戏id：”并调用捕获PrintLog | `accountPrintLog("游戏id：" .. tostring(gameID))` | 一致 |
| PC9-PC16 | GAME_ID与数值204208比较；不符时输出“游戏不一致，id：”并提前返回 | if判断、日志、return | 一致 |
| PC17-PC24 | 取UID并输出“账号ID：” | `SL:GetMetaValue("UID")`及accountPrintLog | 一致 |
| PC25-PC38 | 按原顺序构造9个字符串账号ID白名单 | `allowedAccountIDs`九项字符串数组 | 一致 |
| PC39-PC41 | 创建Nested_ID闭包并传入accountID | `Nested_ID(accountID)` | 一致 |
| PC42-PC53 | 根据Nested_ID返回值输出成功/失败日志 | validationResult分支与两条日志 | 一致 |
| PC54-PC55 | 将等待闭包捕获槽清为nil；后续闭包捕获nil | `local unScheduleArgument = nil` | 一致 |
| PC56-PC60 | 创建等待回调并调用SL:Schedule(callback,0.5) | `SL:Schedule(scheduledCallback,0.5)` | 一致 |

## 子原型1：Nested_ID（白名单匹配）

- 通过`ipairs(allowedAccountIDs)`按顺序遍历。
- 对传入ID和列表ID分别执行`tostring`后比较。
- 命中时调用捕获的PrintLog输出`[提示] 账号ID在允许列表中，功能已开启`并返回true。
- 全部未命中时调用捕获的ShowLocalNoticeByType，消息拼接传入ID，并返回false。
- 源码Nested_ID循环、两侧tostring、日志/通知文本和返回值均与指令一致。

## 子原型0：等待主界面属性栏回调

- 读取MainProperty，检查`MainProperty._ui.Panel_mini_chat`路径。
- 条件满足时按原顺序调用`SL:UnSchedule(nil)`，再读取MainLeftBottom并调用其doInit字段。
- 无论条件是否满足，均输出“等待主界面属性栏(MainProperty)初始化完成...”。
- 源码scheduledCallback保留相同条件、`unScheduleArgument=nil`、UnSchedule调用、`getfenv(1).MainLeftBottom.doInit()`和日志位置。
- Lua 5.1中函数环境通过getfenv(1)读取当前回调chunk环境，与VM GETGLOBAL MainLeftBottom的环境访问方式相符。

## 捕获及执行顺序

1. root PC276-PC278捕获PrintLog与ShowLocalNoticeByType，PC279挂入MainLeftBottom.main；源码以accountPrintLog/accountShowLocalNotice固定相同函数身份。
2. Nested_ID由AccountIDValidation内部创建，捕获白名单表和两个父级日志/通知闭包。
3. PC55清空捕获寄存器后，等待回调捕获的是nil；不是Schedule返回句柄，也不是Nested_ID验证结果。
4. Schedule调用在验证结果日志之后，延迟参数0.5与VM一致。

## 结论

AccountIDValidation主原型和两个直接子原型完成本轮逐段核对，未发现明确源码错配，不修改唯一交付源码。

保留VM行为：`SL:UnSchedule(nil)`。未执行Lua 5.1编译及目标游戏运行验证。

## 下一步

开始doInit_UI主体419条指令及23个直接子原型核对。先审查主体初始化顺序、20项捕获槽、资源统计窗口和按钮创建/点击回调。