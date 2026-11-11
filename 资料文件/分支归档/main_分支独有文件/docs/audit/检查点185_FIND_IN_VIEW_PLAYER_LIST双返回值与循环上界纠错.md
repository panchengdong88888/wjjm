# 检查点 #185：FIND_IN_VIEW_PLAYER_LIST 双返回值与循环上界纠错

日期：2026-11-10
原型：root.children[47] / BlacklistPlayerDetection（216条）。

## 指令证据

- PC63-PC65取得SL:GetMetaValue及键FIND_IN_VIEW_PLAYER_LIST。
- PC66为多返回值调用（OP_233，A=2、C=3），把调用结果的两个返回值写入连续返回槽。
- PC67检查第一个返回值（player list）truthy；失败路径PC68跳至PC73 return。
- PC69检查第二个返回值（playerCount）truthy；失败路径PC70跳至PC73 return。
- PC71检查playerCount <= 0；PC72跳至PC73 return。
- PC74-PC77以1为初始索引、第二返回值为循环上界、1为步长，PC215执行循环增量/回跳。

## 源码纠错

旧草稿及检查点184的更新版曾写成：
- 单接收players；
- 再用#players计算playerCount。

这与字节码不符。PC66显式收集两个返回值，且PC69/PC71直接检查第二返回值；PC63-PC77之间没有对players执行长度运算的指令。现改为：

local players, playerCount = SL:GetMetaValue("FIND_IN_VIEW_PLAYER_LIST")
if not players then return end
if not playerCount then return end
if playerCount <= 0 then return end
for index = 1, playerCount do ... end

不推断第二返回值的宿主数据契约以外含义；其在本函数中明确作为数字循环上界使用。

## 状态

- root.children[47] 的PC63-PC77数据流现已与双返回值调用及数字循环上界一致。
- root.children[47]仍为普通Lua草稿；仍需完成PC1-PC73、PC142-PC216全函数合并复核后再决定是否升级。
- 统计维持普通Lua草稿72、完整静态恢复101/110、运行时验证0。
