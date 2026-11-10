# 检查点192：root模块初始化PC1-PC41首段草稿

日期：2026-11-10

## 对象与范围
- 原型：`root` / `MainLeftBottom_Module`
- 规模：412条物理指令、109常量、58个直接子原型
- 本次范围：仅PC1-PC41；不宣称完整恢复root。
- 源码：`04_源码候选/root_MainLeftBottom_Module.lua`

## 本批闭合内容
- PC1-PC2：创建模块表并写入全局`MainLeftBottom`。
- PC3-PC5：创建独立的`a`表并挂接到`MainLeftBottom.a`。
- PC6：`a.version = "10000"`。
- PC7-PC16：依次调用`SL:GetMetaValue("SCREEN_WIDTH")`、`SL:GetMetaValue("SCREEN_HEIGHT")`，写入`a.screenW`和`a.screenH`。
- PC17-PC22：创建四项数组，顺序为`1.0, 9.0, 10.0, 60000.0`。
- PC23-PC29：将该数组写入`a.Blocklist`；创建`a.SendHookList`、`a.RecvHookList`空表；设置`a.isHidden=true`、`a.hidebut=nil`。
- PC30-PC41：创建`MainLeftBottom.b`与`MainLeftBottom.z`；z初始化`isPaused/isRunning/isStoring/isTaking/isDiuing/isOutputted`六个false字段。

## 边界与未决
- 本批没有重新执行内层解码、全量VM dump、Opcode研究、闭包索引或指令级去虚拟化。
- PC42-PC412尚未转写为普通Lua主体，包含全局函数注册、嵌套闭包创建、黑名单状态表、MainLeftBottom.main及doInit等。
- 根模块的a/b/z字段后续是否还有额外赋值，需按PC顺序继续确认。
- 未做目标Lua/游戏客户端运行时验证；当前仅为根模块首段普通Lua草稿。
- 不将根模块计入完整静态恢复数。

## 统计
- 普通Lua草稿函数/原型：72（新增root分段草稿1项；原71项不变）。
- 完整静态恢复：103/110（93.6%，不变）。
- 运行时验证：0。
- 检查点：192。

## 下一步
继续root PC42-PC137：先闭合代理/日志辅助函数创建、全局函数注册与早期初始化，再按PC分段推进PC138-PC412；不一次性猜写未闭合的upvalue或宿主语义。
