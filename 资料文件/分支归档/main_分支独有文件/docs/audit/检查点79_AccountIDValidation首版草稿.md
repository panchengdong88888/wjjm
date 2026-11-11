# 检查点 #79：AccountIDValidation 首版普通 Lua 草稿

日期：2026-11-09

## 原型身份
- 函数索引105；规范路径`root.children[55]`；legacy`root/56`
- 64条物理指令、21个常量、2个子原型、`vararg_flag=0`
- 根函数PC276创建闭包，捕获root T[4]、root T[5]

## 主体恢复
源码：`04_源码候选/短函数草稿_第五十五批.lua`

- PC1-PC9：读取`SL:GetMetaValue("GAME_ID")`，通过捕获回调输出游戏ID。
- PC10-PC17：将GAME_ID与常量`204208`比较，不一致时输出“游戏不一致，id：...”并返回。
- PC18-PC26：读取UID并输出“账号ID：...”。
- PC27-PC37：构造9项字符串允许列表，常量值依次为6324648、39770358、3548598、1957840929、1488903257、1585201915、1627987432、1580027021、1304755149。
- PC38-PC50：创建并调用子原型Nested_ID；子原型遍历允许列表，将条目与传入UID的tostring结果比较；命中/未命中分别输出提示并返回布尔值；父函数根据布尔值再输出验证成功/失败提示。
- PC55-PC64：调用SL.Schedule安排0.5秒延迟的界面初始化检查回调。

## 子原型
- Nested_Panel_mini_chat（root.children[55].children[0]，24条指令）：检查MainProperty、_ui、Panel_mini_chat；已初始化时调用SL.UnSchedule(捕获值)及MainLeftBottom.doInit；未初始化时输出等待提示。捕获父T[4]与父UPVALUE_0。
- Nested_ID（root.children[55].children[1]，27条指令）：遍历捕获的允许列表，比较UID；捕获父R2、父UPVALUE_0、父UPVALUE_1。

## 待复核
- 主函数UPVALUE_0/UPVALUE_1（root T[4]/T[5]）业务身份。
- Nested_ID捕获回调与提示顺序。
- Nested_Panel_mini_chat捕获的父T[4]具体是什么，是否确为UnSchedule句柄。
- SL.Schedule实参顺序及返回契约。
- GAME_ID/UID的转换和拼接细节。
- 未运行时验证；不升级完整静态恢复。
