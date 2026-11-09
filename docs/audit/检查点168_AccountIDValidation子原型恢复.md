# 检查点 #168：AccountIDValidation 两个子原型的普通 Lua 恢复

日期：2026-11-09
仓库：panchengdong88888/wjjm
目标：
- root.children[55].children[0] / legacy root/56/1 / Nested_Panel_mini_chat（24 条）
- root.children[55].children[1] / legacy root/56/2 / Nested_ID（27 条）

## 本批产物

新增 `04_源码候选/root55_children_drafts.lua`，将两个子原型整理为可读普通 Lua。没有把父函数 AccountIDValidation 的尚未闭合调度捕获映射冒充完整恢复。

## Nested_Panel_mini_chat

- PC1-3：读取全局 MainProperty；假值跳至等待提示路径。
- PC4-7：再次读取 MainProperty._ui；假值同样跳至等待提示路径。
- PC8-12：读取 MainProperty._ui.Panel_mini_chat；假值跳至等待提示路径。
- PC13-16：取 SL.UnSchedule 并以捕获 UP[0] 作为唯一显式参数调用；SL 为方法 receiver。
- PC17-19：调用 MainLeftBottom.doInit()，零显式参数。
- PC21-23：所有路径都会调用 UP[1]，参数固定为“等待主界面属性栏(MainProperty)初始化完成...”。
- PC24：返回，无显式返回值。
- 子函数体控制流可读化完成；UP[0]/UP[1] 的父级具体生产者仍未闭合，因此保留为 timerHandle/showWaitingNotice 工厂占位，不把用途推断当作来源证明。

## Nested_ID

- PC1-3：建立 ipairs(UP[0]) 迭代器。
- PC5-7：对第一个显式参数 accountID 执行 tostring。
- PC8-11：对当前 allowedID 执行 tostring，并与前者作相等比较。
- PC13-17：匹配时调用 UP[1]，传入固定成功提示；返回 true。
- PC18-19：迭代器继续，index 为 nil 时退出循环。
- PC20-24：遍历结束未命中时，调用 UP[2]，参数为固定前缀拼接原始 accountID 的 tostring；返回 false。
- PC27 位于显式返回后的尾部，不参与正常路径。
- 仅读取第一个显式参数；额外变参没有被读取。
- 父 AccountIDValidation PC38 的捕获顺序与子原型用法对应：允许列表、成功提示回调、失败提示回调。运行时行为未验证。

## 统计口径

- 本批新增普通 Lua 草稿文件：1 个，包含 2 个子原型。
- Nested_ID：提升为完整静态恢复（未运行时验证）。
- Nested_Panel_mini_chat：保留首版/完善后的草稿状态，等待父级捕获生产者核验。
- 本批没有增加运行时验证数量。
- 不将父函数 AccountIDValidation 计为完成。

## 下一步

核对 root.children[55] PC27-64 的父级调用与调度捕获，尤其是 Nested_Panel_mini_chat 的两个捕获值、Schedule 参数顺序和 Nested_ID 的实参来源；然后再批量处理其他仍为首版草稿的短函数。
