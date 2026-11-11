# 检查点 #120：Nested_Helper_10 黑名单开关静态恢复

日期：2026-11-09
原型：`root.children[42].children[18]` / `root/43/19`
指令：39；常量：9；子原型：0；vararg_flag：0

## 一、父闭包捕获映射

doInit_UI（`root.children[42]`）PC299创建本闭包，capture_count=6。PC300-PC305顺序如下：

| 子函数UP槽 | 父来源 | 已确认用途 |
|---|---|---|
| UP[0] | doInit_UI UP[2] | 定时器状态表，读取/清理blacklistTimer |
| UP[1] | doInit_UI UP[0] | 通知回调；父函数该槽已确认PrintLog |
| UP[2] | doInit_UI UP[1] | MainLeftBottom模块状态表，写入isBlacklisting=false |
| UP[3] | doInit_UI UP[6] | 零参数调用，返回距离值；上游业务身份仍未知 |
| UP[4] | doInit_UI T[19] | 零参数调用，仅在无正距离路径执行；业务身份仍未知 |
| UP[5] | doInit_UI T[16] | 单参数调用，传入距离值；业务身份仍未知 |

UP[3..5]在候选中按调用行为命名为getDistance/openDistanceInput/onDistanceAvailable。这些是用途标签，不宣称是作者原名。捕获源寄存器与实参数量由PC299-PC305及本体调用点证明。

## 二、控制流恢复

### 关闭路径：PC1-PC18

1. PC1-PC2读取UP[0].blacklistTimer。
2. 存在定时器时进入关闭分支。
3. PC5-PC7调用UP[1]，参数为“关闭黑名单功能”。
4. PC8-PC12取得SL.UnSchedule方法并调用，接收者SL与timerState.blacklistTimer均进入参数序列。
5. PC13-PC14将UP[0].blacklistTimer写为nil哨兵。
6. PC15-PC16将UP[2].isBlacklisting写为false。
7. PC17-PC18返回true。

### 距离判定及无正距离路径：PC19-PC29

1. PC19-PC20调用UP[3]()，返回值保留在R0。
2. PC21-PC22的条件跳转组合将正距离路径分流至PC30；非正距离走PC23-PC29。
3. PC23-PC25调用UP[1]，传入固定提示“路径中没有黑名单的距离格子，弹出输入框”。
4. PC26-PC27调用UP[4]()，无显式实参。
5. PC28将返回值寄存器设为false，PC29返回false。

### 正距离路径：PC30-PC38

1. PC30-PC33调用UP[1]，参数为格式串“开启黑名单功能，距离格子：%d”和PC19-PC20取得的距离值。
2. PC34-PC36调用UP[5](distance)，恰传一个距离实参。
3. PC37将返回值设为true，PC38返回true。

因此可读候选使用`if distance > 0 then`表达正距离分支；0、负值或非正路径不会进入开启回调。

## 三、候选源码

新增：`04_源码候选/Nested_Helper_10_黑名单功能开关_第八十批.lua`

完整映射39条指令，保留三个尚未命名的捕获回调槽位，不虚构其上游业务身份。定时器关闭、距离获取、通知、输入回调、距离回调及三种返回结果均按物理PC映射。

## 四、语义边界

- `["unknown",2]`在PC14是dump中的nil序列化哨兵；候选用nil表达，尚未宿主运行时验证。
- UP[3]返回距离值、UP[4]为无参数交互回调、UP[5]接收距离值，这些调用契约由本体指令证明；回调具体实现/业务身份尚未追出。
- 没有推断UP[5]一定会创建定时器或执行BlacklistItems；本函数本体只证明调用UP[5](distance)。
- 无游戏客户端运行时验证。

## 五、统计

普通Lua草稿78；完整静态恢复61/110；运行时验证0。此次将Nested_Helper_10从首版草稿提升为完整静态恢复；未将其计入运行时验证。
