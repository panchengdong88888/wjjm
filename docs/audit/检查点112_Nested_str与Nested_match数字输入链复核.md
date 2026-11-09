# 检查点 #112：Nested_str / Nested_match / Nested_Helper_11数字输入链复核

日期：2026-11-09

## 原型身份
| 函数 | 规范路径 | legacy | 指令 | 常量 | 子原型 | vararg |
|---|---|---|---:|---:|---:|---:|
| Nested_str | root.children[42].children[22].children[0] | root/43/23/1 | 27 | 13 | 1 | 1 |
| Nested_match | root.children[42].children[22].children[0].children[0] | root/43/23/1/1 | 50 | 14 | 1 | 2 |
| Nested_Helper_11 | root.children[42].children[22].children[0].children[0].children[0] | root/43/23/1/1/1 | 4 | 1 | 0 | 0 |

## 捕获映射
### Nested_str
由Nested_Anonymous PC1创建，捕获顺序：
- UP[0] <- Nested_Anonymous T[0]。
- UP[1] <- Nested_Anonymous UP[0]。
- UP[2] <- Nested_Anonymous T[2]。
- UP[3] <- Nested_Anonymous T[1]。

### Nested_match
由Nested_str PC17创建：
- UP[0] <- Nested_str UP[1]。
- UP[1] <- Nested_str UP[0]。
- UP[2] <- Nested_str UP[2]。
- UP[3] <- Nested_str UP[3]。

### Nested_Helper_11
由Nested_match PC42创建：
- UP[0] <- Nested_match UP[2]：延迟错误提示回调。

## Nested_str逐PC
- PC1-PC7：创建dialogParams，btnType=2、showEdit=true、editParams={inputMode=2,maxLength=6}。
- PC8-PC9：dialogParams.str初始取UP[0]。
- PC10-PC16：第一个变参suffix truthy时，将原文本追加换行符及suffix；false/nil时不追加。
- PC17-PC22：创建Nested_match回调并写入dialogParams.callback。
- PC23-PC26：调用SL:OpenCommonTipsPop(dialogParams)。
- PC27返回。

## Nested_match逐PC
- PC1-PC3：status不严格等于数值1时返回。
- PC4-PC9：读取result.editStr；result或editStr false/nil时使用空字符串，不提前返回。
- PC10-PC17：执行`tostring(editStr):gsub("%s","")`，删除所有空白。
- PC18-PC22：执行`string.match(normalized,"^%d+$")`。
- PC23-PC24：纯数字匹配失败时跳至错误提示段；成功时进入tonumber转换。
- PC25-PC30：调用tonumber(normalized)；转换结果false/nil时转入错误提示段。
- PC31-PC32：numericValue truthy时跳过错误段，进入成功回调。
- PC33-PC39：调用UP[0]，实参为格式模板`"%s：参数格式不对（%s）"`、UP[1]、`tostring(editStr)`。PC38的多返回值与PC39开放参数调用按VM调用约定保留。
- PC40-PC45：创建Nested_Helper_11，调用SL:ScheduleOnce(callback,0.1)。
- PC46返回。
- PC47-PC49：成功路径调用UP[3](numericValue)。
- PC50返回。

## Nested_Helper_11
- PC1读取UP[0]。
- PC2加载固定文本“参数格式不对，请输入数字”。
- PC3调用UP[0](message)。
- PC4返回。

## 关键纠正与保留边界
1. 旧草稿将`if not result then return`写入Nested_match；该行为与PC4-PC9不符。正确行为是result缺失时editStr回退空串并继续校验，随后进入数字格式错误提示。
2. 空白删除发生在数字匹配之前，正则为`^%d+$`。
3. 错误模板回调接收三个实参；延迟提示回调在0.1秒后触发。
4. 数字转换成功后才调用UP[3](numericValue)。
5. Nested_Anonymous父包装函数仅8条指令，仍未完成：其T[0]/T[1]/T[2]实际参数映射、R2()调用业务身份、调用者实参布局尚未闭合。因此本批只升级三个子原型，不升级Nested_Anonymous。

状态：Nested_str、Nested_match、Nested_Helper_11均完成静态恢复（未运行时验证）；Nested_Anonymous仍为草稿。
