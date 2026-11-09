# 检查点 #105：Nested_Helper_5 / Nested_Helper_8 回调主体静态复核

日期：2026-11-09

## 原型身份
| 函数 | 规范路径 | legacy | 物理指令 | 常量 | 子原型 | vararg |
|---|---|---|---:|---:|---:|---:|
| Nested_Helper_5 | root.children[42].children[11].children[0] | root/43/12/1 | 35 | 6 | 0 | 1 |
| Nested_Helper_8 | root.children[42].children[14].children[0] | root/43/15/1 | 34 | 5 | 0 | 1 |

## 捕获来源

### Nested_Helper_5
由Nested_Helper_4创建的子闭包，依次捕获Nested_Helper_4的UP[1..7]：
1. UP[0]：输入值校验回调。
2. UP[1]：通用通知回调。
3. UP[2]：模板消息回调（父root的T[0]）。
4. UP[3]：失败上下文解析回调（父root的UP[12]）。
5. UP[4]：失败上下文参数（父root的UP[13]）。
6. UP[5]：黑名单距离保存回调（父root的T[16]）。
7. UP[6]：按钮状态回调（父root的T[15]）。

Nested_Helper_4本身在root/43 PC250创建，8项捕获依次为父T[18]、父UP[10]、父UP[11]、父T[0]、父UP[12]、父UP[13]、父T[16]、父T[15]。因此上述子闭包映射与两级捕获链一致。

### Nested_Helper_8
由Nested_Helper_7创建的子闭包，依次捕获Nested_Helper_7的UP[1..7]：
1. UP[0]：输入值校验回调。
2. UP[1]：通用通知回调。
3. UP[2]：模板消息回调（父root的T[0]）。
4. UP[3]：失败上下文解析回调（父root的UP[12]）。
5. UP[4]：失败上下文参数（父root的UP[13]）。
6. UP[5]：怪物阈值保存回调（父root的T[17]）。
7. UP[6]：按钮状态回调（父root的T[15]）。

Nested_Helper_7本身在root/43 PC259创建，8项捕获依次为父T[18]、父UP[14]、父UP[11]、父T[0]、父UP[12]、父UP[15]、父T[17]、父T[15]。

## Nested_Helper_5逐PC恢复
- PC1-PC3：读取UP[0]和首个变参value，调用validateValue(value)。
- PC4-PC5：truthy时跳转到PC16成功段；false/nil进入失败段。
- PC6-PC8：调用UP[1]("黑名单距离保存失败")。
- PC9-PC12：加载模板消息回调、失败模板、失败上下文解析回调及其参数。
- PC13 OP_392：调用resolveFailureContext(failureContext)，将多个返回值写入连续寄存器。
- PC14开放参数调用：formatCallback("黑名单距离保存失败，路径：%s", ...pathResults)。PC15返回。
- PC16-PC21：调用通知回调，消息为"黑名单距离已保存："..value.." 格"。
- PC22-PC25：调用模板消息回调("黑名单距离已保存：%d 格", value)。
- PC26-PC28：调用黑名单距离保存回调(value)，取得其返回值。
- PC29-PC30：仅当保存回调返回false/nil时跳过按钮启用；truthy时进入PC31。
- PC31-PC34：调用按钮状态回调("blacklistbut", true)。
- PC35尾部return。

## Nested_Helper_8逐PC恢复
- PC1-PC3：调用校验回调(value)。
- PC4-PC5：truthy时跳转至PC16成功段；false/nil进入失败段。
- PC6-PC8：调用通知回调("怪物阈值保存失败")。
- PC9-PC14：按相同开放返回/开放实参结构，调用模板消息回调("怪物阈值保存失败，路径：%s", ...resolveFailureContext(failureContext))。
- PC15返回。
- PC16-PC20：调用通知回调("怪物阈值已保存："..value)。
- PC21-PC24：调用模板消息回调("怪物阈值已保存：%d", value)。
- PC25-PC27：调用阈值保存回调(value)。
- PC28-PC29：保存回调false/nil时跳过按钮启用；truthy时进入PC30。
- PC30-PC33：调用按钮状态回调("yinguaibut", true)。
- PC34尾部return。

## 关键语义核对
- OP_342：`if (not not R[A]) ~= (C ~= 0) then Q=Q+1 end`。两函数均在校验结果truthy时执行PC5跳转至成功段；false/nil落入失败段。
- OP_392：执行函数调用并将多个返回值写入连续T寄存器。
- 紧随其后的开放参数调用将格式字符串与上述多返回值一并传给模板消息回调；源码用最后一个表达式的多返回值展开表达这一点。
- 保存回调的返回值参与分支，只有truthy才启用相应按钮。
- PC31/PC30的按钮回调均为两个实参：按钮key及true。

## 保留边界
- 父T[0]回调及UP[12]/UP[13]的业务实现需在父级初始化链继续追踪；本批按调用形状命名，不推断其宿主具体实现。
- “路径解析回调”和“失败上下文参数”是行为名称，未证明作者原始变量名。
- 未进行游戏客户端运行时验证。

状态：两个回调均完成静态恢复（未运行时验证）。
