# 检查点 #59：Nested_str 与 Nested_match 普通 Lua 草稿

日期：2026-11-09

## 新增草稿
新增文件：`04_源码候选/短函数草稿_第三十六批.lua`

### Nested_str
- 规范路径：`root.children[42].children[22].children[0]`
- legacy：`root/43/23/1`
- 原型索引：85；物理指令27；常量13；子原型1
- 静态事实：构造 `btnType=2`、`showEdit=true` 的弹窗参数；`editParams.inputMode=2`、`maxLength=6`；`str` 来自 UPVALUE_0；可选参数为真时追加换行和附加文本；设置 callback 并调用 `SL:OpenCommonTipsPop`。

### Nested_match
- 规范路径：`root.children[42].children[22].children[0].children[0]`
- legacy：`root/43/23/1/1`
- 原型索引：86；物理指令50；常量14；子原型1
- 静态事实：首参须等于1；第二参为空则返回；读取 `editStr`，缺失时用空字符串；`tostring` 后用 `gsub("%s","")` 删除空白；使用 `^%d+$` 匹配并调用 `tonumber`；成功时调用 UPVALUE_3 并传入数字。
- 非法输入分支使用模板 `%s：参数格式不对（%s）`，并创建/调度 Nested_Helper_11；固定提示为“参数格式不对，请输入数字”，延迟常量0.1。

## 捕获关系
Nested_str:
- UPVALUE_0 <- Nested_Anonymous 的当前 T[0]
- UPVALUE_1 <- Nested_Anonymous 的 UPVALUE_0
- UPVALUE_2 <- Nested_Anonymous 的当前 T[2]
- UPVALUE_3 <- Nested_Anonymous 的当前 T[1]

Nested_match:
- UPVALUE_0 <- Nested_str.UPVALUE_1
- UPVALUE_1 <- Nested_str.UPVALUE_0
- UPVALUE_2 <- Nested_str.UPVALUE_2
- UPVALUE_3 <- Nested_str.UPVALUE_3

Nested_Helper_11 已在第十五批存在草稿，其捕获回调接收“参数格式不对，请输入数字”。

## 未解决项
1. Nested_Anonymous 父级调用消费点和 vararg 关系未完全闭合，本批不计入草稿完成数。
2. UPVALUE_0..3 仍采用中性槽位名，未强行赋予业务名称。
3. ScheduleOnce 参数列表中 UPVALUE_2 与 Nested_Helper_11 的精确对应关系仍需独立复审；当前代码为可读草稿，不视为作者级逐字恢复。
4. 本批未运行时验证，不增加完整静态恢复数量。

## 统计
- 普通 Lua 草稿：45 -> 47（新增 Nested_str、Nested_match）
- 完整静态恢复：27/110，不变
- 运行时验证：0，不变
- 最新检查点：#59

## 下一步
继续追踪 Nested_Anonymous 的父级调用消费点和 vararg 参数来源，并独立复审 Nested_match 的 ScheduleOnce 参数；随后优先处理尚未开始的短函数。
