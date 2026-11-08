# 检查点 #21：PrintLog 日志辅助函数恢复

日期：2026-11-08

## 对象
`root.children[16]` / legacy `root/17` / PrintLog，38 条物理指令，无子原型，vararg 函数。

## 已恢复代码
新增 `04_源码候选/PrintLog_日志辅助函数_第七批.lua`。

控制流：
1. PC1–3：对第一个参数执行 `type`。
2. PC4–5：若为 table，转入专用分支；非 table 跳过该分支。
3. PC6–10：table 分支调用 `SL.dump(value, "【超本】"))，然后 return。
4. PC12–14：非 table 分支执行 `tostring(value)`。
5. PC15–20：通过 `select("#", ...)` 判断是否存在额外格式参数。
6. PC21–30：有额外参数时执行 `pcall(string.format, message, ...)`；成功且结果 truthy 时复制格式化结果。
7. PC31–37：检查 `SL` 和 `SL.Print` 是否存在，但活动指令中没有后续调用指令。草稿保留空检查，不擅自补上 `SL.Print(message)`。

## 结论
该原型所有可达分支均已形成普通 Lua 表达；PC31–37 的 Print 成员仅被读取和测试，没有调用。即使这与函数名 PrintLog 的直觉不符，也按字节码行为保留，不推测作者意图。

状态：完整静态恢复（未运行时验证）。
