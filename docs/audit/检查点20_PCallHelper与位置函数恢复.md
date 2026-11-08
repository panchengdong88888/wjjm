# 检查点 #20：PCallHelper 文件写入包装器与位置函数核对

日期：2026-11-08

## 一、纠正原型身份与路径

根据原型索引和 corrected disassembly：
- `root.children[17]` / legacy `root/18` 是 `PCallHelper`，14 条指令，含 1 个子原型。
- `root.children[17].children[0]` / legacy `root/18/1` 是 `Nested_tostring`，14 条指令。
- `root.children[18]` / legacy `root/19` 才是 `GetPlayerPosition`，19 条指令，无子原型。
此前机器状态中“root.children[18] 是文件写入 pcall wrapper”的路径表述不正确；本检查点及 CSV 已按 0-based 规范纠正。

## 二、PCallHelper 已恢复的确定语义

`root.children[17]`：
- PC1 取全局 `pcall`。
- PC2 创建 `root/18/1` 子闭包，捕获 3 个值。
- PC3–5 准备闭包和捕获参数。
- PC6 调用 pcall，接收两个结果。
- PC7–13 根据 pcall 成功标志和子函数返回值精确归一化布尔结果：
  - pcall 失败 -> false；
  - pcall 成功但子函数结果严格等于 false -> false；
  - pcall 成功且结果不是 false（包括 nil）-> true。

因此父包装器返回契约可静态完整恢复为：
`local ok, result = pcall(writer); return ok and result ~= false`
（实际 child 闭包及其捕获参数见下文）。

## 三、子闭包的首版代码

新增 `04_源码候选/PCallHelper_文件写入包装_第六批草稿.lua`：
- child PC1–5：解析 `cc.FileUtils:getInstance():writeStringToFile`。
- PC6–8：取得全局 `tostring`，将 UP[0] 转换为字符串。
- PC9–11：读取另外两个捕获值并进入调用点。
- child 三个捕获来源由 parent PC2–5 描述：parent T[1]、parent UP[0]、parent T[0]。

子闭包已形成可读首版，但 OP_004/OP_252 融合载荷中调用接收者及参数顺序尚未独立展开；代码中明确标注 provisional，不计入完整静态恢复。

## 四、GetPlayerPosition 复核状态

`root.children[18]`：
- PC1–4：调用 `SL:GetMetaValue("X"))。
- PC5–7：X 的 false/nil 分支进入 PC7 融合指令，首个可见赋值为 0；当前草稿将其表达为 `x = x or 0`。
- PC8–11：调用 `SL:GetMetaValue("Y"))。
- PC12–14：Y 的 false/nil 分支进入 PC14 融合表构造；当前草稿暂写 `y = y or 0`，但 PC14 还包含 table create/field assignment 的融合微操作，必须保留待核注释。
- PC15–18：构造并返回 `{x=x, y=y})。

当前仍为首版草稿，不提升为完整静态恢复。

## 五、数量与后续

- 完整静态恢复数量：15（本批没有新增完整静态函数）。
- 运行时验证：0。
- 新增首版草稿：PCallHelper 与 Nested_tostring；GetPlayerPosition 保留待核草稿。
- 下一步：展开 PCallHelper child 的 OP_004/OP_252 参数；复核 ShowLocalNoticeByType 的 UP[0] 捕获对象；然后处理 root.children[16] PrintLog 和 root.children[19] InitGatherMonsters 的简单部分。
