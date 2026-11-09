# 检查点 #174：Nested_isOutputted 完整静态复审

日期：2026-11-09
目标：root.children[50].children[0] / legacy root/51/1 / Nested_isOutputted（52条，2项捕获，vararg标志2）。

## 父级捕获来源

父函数 StorageItems（root.children[50] / legacy root/51）PC102创建 child[0]；PC103、PC104依次捕获父 UP[0]、父 UP[1]。子函数的实际读写用途明确：

- 子 UP[0]：共享输出状态对象，访问并设置 `isOutputted` 字段。
- 子 UP[1]：输出回调，接收物品记录和拼接后的详情文本。

更上层父 UP[0]/UP[1] 的业务原名尚未恢复；源码采用 `outputState`、`outputCallback` 功能性名称，不伪称原始变量名。

## 父级参数调用点

父 StorageItems PC154-PC156以 `ipairs(R8)` 建立迭代；PC158-PC166对当前物品 Name 与当前迭代值进行纯文本查找。命中后 PC167-PC170调用 PC102创建的闭包，显式传入当前物品记录 R19 和当前迭代值 R25。故子函数参数顺序为 `item, itemText`，不是猜测的参数映射。PC171接收子函数返回值并继续父级分支。

## 子函数逐段控制流（52条）

- PC1-PC9：执行 `string.find(itemText, "聚灵珠", 1, true)`；未命中直接返回 true。
- PC10-PC13：读取共享状态 `outputState.isOutputted`；已输出则跳过首次输出段。
- PC14-PC18：未输出时置 `isOutputted=true`，调用输出回调并传入当前物品记录。
- PC19-PC37：拼接“聚灵珠信息: ”以及 Name、StdMode、Dura、DuraMax 的 tostring 结果，再调用输出回调。
- PC38-PC40：检查 item.Dura；缺失则返回 false。
- PC41-PC43：检查 item.DuraMax；缺失则返回 false。
- PC44-PC49：比较 Dura 与 DuraMax，按比较结果走布尔返回分支。
- PC50-PC52：完成另一布尔返回路径及最终 return。

全52条物理指令、两项捕获、两项显式参数、字符串查找、首次输出状态写入、两次回调及数值字段校验/返回路径均已对照父级调用点复核。额外 vararg 未见读取。

## 状态

- Nested_isOutputted：完整静态恢复，未运行时验证。
- 普通 Lua 草稿：78。
- 完整静态恢复：95/110。
- 运行时验证：0。
- 源码候选：`04_源码候选/短函数草稿_第三十四批.lua`。
