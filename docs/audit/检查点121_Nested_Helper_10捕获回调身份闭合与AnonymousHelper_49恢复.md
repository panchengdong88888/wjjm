# 检查点 #121：Nested_Helper_10 捕获回调身份闭合与 AnonymousHelper_49 恢复

日期：2026-11-09

## 一、Nested_Helper_10剩余捕获身份全部闭合

对象：`root.children[42].children[18]` / `root/43/19`。

此前检查点120已确认父doInit_UI PC299创建6捕获闭包，PC300-PC305捕获顺序为父UP[2]、UP[0]、UP[1]、UP[6]、T[19]、T[16]。本批继续回溯后三项来源：

| Nested_Helper_10槽位 | doInit_UI来源 | 精确身份 | 证据 |
|---|---|---|---|
| UP[3] | doInit_UI UP[6] | AnonymousHelper_49 | doInit_UI UP[6]来自root T[48]；root PC304创建root.children[49]并存入R48；该闭包捕获ReadNumericConfig与文件名 |
| UP[4] | doInit_UI T[19] | Nested_Helper_4 | doInit_UI PC250创建root.children[42].children[11]并存入R19；PC304捕获R19 |
| UP[5] | doInit_UI T[16] | Nested_blacklistTimer | doInit_UI PC239创建root.children[42].children[17]并存入R16；PC305捕获R16 |

因此Nested_Helper_10的6项捕获现在全部具名：
- UP[0] timerState（doInit_UI UP[2]）
- UP[1] PrintLog/通知回调（doInit_UI UP[0]）
- UP[2] MainLeftBottom模块状态表（doInit_UI UP[1]，写isBlacklisting）
- UP[3] AnonymousHelper_49（读取blacklist_distance.txt）
- UP[4] Nested_Helper_4（打开距离输入提示/对话框）
- UP[5] Nested_blacklistTimer（接收距离，启动黑名单处理）

## 二、AnonymousHelper_49完整静态恢复

原型：`root.children[49]` / `root/50`，5条指令、0常量、无子原型。

root PC304创建闭包，PC305-PC306按顺序捕获：
1. UP[0] <- root R45：root.children[9] ReadNumericConfig闭包。
2. UP[1] <- root R42：字符串`blacklist_distance.txt`（root PC295装载）。

本体PC1-PC3调用UP[0](UP[1])并原样返回所有返回值；PC4-PC5在无条件return之后，不可达。

因此源码恢复为：

```lua
local function AnonymousHelper_49()
    local readNumericConfig = UPVALUE_0
    local configFileName = UPVALUE_1
    return readNumericConfig(configFileName)
end
```

ReadNumericConfig本体（root.children[9]）检查文件并读取文本；字符串会移除空白，纯数字转为tonumber，其他字符串原样返回。AnonymousHelper_49只负责固定文件名的转发，不在自身内重复这些处理。

doInit_UI PC303-PC304将root R48（AnonymousHelper_49闭包）捕获为doInit_UI UP[6]，随后doInit_UI PC299创建Nested_Helper_10时又把该UP[6]作为Nested_Helper_10 UP[3]。

## 三、源码修改

1. `04_源码候选/短函数草稿_第十六批.lua`
   - AnonymousHelper_49补齐精确捕获身份和文件名。
   - 仅将AnonymousHelper_49标记为完整静态恢复；同文件另两个函数仍为草稿。
2. `04_源码候选/Nested_Helper_10_黑名单功能开关_第八十批.lua`
   - UP[3]明确为readBlacklistDistance。
   - UP[4]明确为Nested_Helper_4输入提示包装器。
   - UP[5]明确为Nested_blacklistTimer。
   - 正距离路径改为明确调用`Nested_blacklistTimer(distance)`；无正距离路径调用`Nested_Helper_4()`。
3. `02_基础索引/03_函数状态清单.csv`
   - AnonymousHelper_49由首版草稿升级为完整静态恢复。
   - Nested_Helper_10记录6项捕获全部闭合。

## 四、统计

普通Lua草稿78；完整静态恢复62/110；运行时验证0。

本批新增1个完整静态恢复函数（AnonymousHelper_49）；Nested_Helper_10仅补齐捕获身份和源码命名，不重复计数。两者均未运行时验证。

## 五、下一步

继续推进doInit_UI尚未完成的父级逻辑或其他有完整证据的草稿函数。Nested_Anonymous的T槽映射仍需VM帧初始化实现；当前仓库没有VM解释器/加载器源码，不以本次闭合的普通闭包捕获关系替代其未知调用帧规则。
