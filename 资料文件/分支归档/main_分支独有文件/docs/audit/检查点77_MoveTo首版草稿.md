# 检查点 #77：MoveTo 首版普通 Lua 草稿

日期：2026-11-09

## 原型身份
- 函数索引5；规范路径`root.children[3]`；legacy`root/4`
- 51条物理指令、20个常量、无子原型、`vararg_flag=3`
- 根函数PC61创建闭包，捕获数0

## 已恢复主体
源码：`04_源码候选/短函数草稿_第五十三批.lua`

- PC1-PC6：创建移动通知数据并读取`SL:GetMetaValue("MAP_ID")`。
- PC7-PC14：参数经`tonumber`转换后写入`x`、`y`字段。
- PC15-PC22：读取`global.MMO.INPUT_MOVE_TYPE_AUTOMOVE`，并写入`range`（缺省路径存在数值0）。
- PC23-PC30：访问`global.Facade.sendNotification`及`global.NoticeTable.InputMove`，发送移动通知。
- PC31-PC32：调用`PlayerPos`取得两个坐标返回值。
- PC33-PC50：分别对x/y轴差值执行`math.abs`并与range比较，最终存在true/false显式返回路径。

## 待复核
- `vararg_flag=3`的精确形式参数声明。
- range的缺省判断条件。
- Facade.sendNotification是否携带self及实际调用参数。
- PlayerPos返回值顺序。
- 两个距离比较的跳转极性及最终true/false的业务含义。草稿中的`deltaX > range and deltaY > range`仅为临时候选，不能视为已确认行为。

## 状态
- 新增普通Lua草稿1个。
- 完整静态恢复仍29/110。
- 运行时验证仍0。
- 不升级完整静态恢复。
