# 检查点 #128：FormatStateChange 与 ReadNumericConfig 普通 Lua 草稿整理

日期：2026-11-09
主工作区：panchengdong88888/wjjm / main

## 本批范围

- `root.children[8]` / legacy `root/9` / FormatStateChange：10 条物理指令。
- `root.children[9]` / legacy `root/10` / ReadNumericConfig：45 条物理指令。

本批遵循草稿优先策略：将已有 PC 分析直接整理为独立普通 Lua 文件，不等待作者原始局部变量名或宿主 API 的外部语义完全确定。

## FormatStateChange 草稿

源码：`04_源码候选/root8_FormatStateChange.lua`

已表达的主体：
1. 通过捕获的 UP[1] 读取旧状态。
2. 以 `string.format("状态切换: %s -> %s", oldState, newState)` 构造消息。
3. 调用捕获的 UP[0]，传入格式化消息。
4. 回调返回后，将 UP[1] 更新为第一个显式参数。

父 root PC181 创建闭包时，捕获来源为 R4 与 R14；捕获槽业务名称未在本批强行命名。原型 vararg 标志为 1；主体只消费首个显式参数，额外变参未见读取。普通 Lua 文件以工厂参数表达捕获单元。

状态：首版普通 Lua 草稿；捕获来源寄存器已知，但形参/T 栈边界和宿主回调契约仍待复核；未运行时验证。

## ReadNumericConfig 草稿

源码：`04_源码候选/root9_ReadNumericConfig.lua`

已表达的主体：
1. 使用唯一捕获 UP[0]（GetWritablePath）解析第一个显式路径参数。
2. 通过 `cc.FileUtils:getInstance()` 获取 FileUtils。
3. 调用 `fileUtils:isFileExist(fullPath)`；不存在时原样返回检查结果。
4. 存在时调用 `getStringFromFile(fullPath)`。
5. 若读取结果不是 string，原样返回。
6. 对字符串执行 `string.gsub(content, "%s", "")` 去除所有 Lua 空白。
7. 用 `string.match(normalized, "^%d+$")` 判断是否仅含 ASCII 数字；命中则 tonumber，否则返回清理后的字符串。

vararg 标志保留为 `function(fileName, ...)`；当前指令体只读取首个显式参数，未见读取额外变参。没有凭空增加默认值、正负号、小数或格式容错。

状态：首版普通 Lua 草稿；调用/返回路径已按反汇编整理，仍需独立静态复审，未运行时验证。

## 统计与后续

本批是把两项已有草稿状态的原型整理成独立文件，不重复计数：
- 普通 Lua 草稿：78（本批新增独立文件 2 个，原型草稿数量不重复增加）。
- 完整静态恢复：69 / 110（62.7%），不变。
- 运行时验证：0，不变。

下一步：独立复核两个新文件，重点核对 FormatStateChange 的 vararg/T 栈映射与 UP[0]/UP[1] 回调时序；ReadNumericConfig 的失败返回值、文件读取多返回值与 string.gsub 返回值接收方式。随后继续批量恢复短函数草稿，并推进 BlacklistPlayerDetection、StorageItems 的主体草稿。


## 检查点 #129 补充：ReadNumericConfig 初始化顺序独立复核

复核发现首版草稿把 GetWritablePath 调用放在 FileUtils:getInstance() 之前，与 PC 顺序不一致。现已修正为：
1. PC1-PC4：先取得 `cc.FileUtils:getInstance()`。
2. PC5-PC7：再调用捕获的 GetWritablePath(fileName)。
3. PC8-PC10：以 FileUtils 实例为接收者调用 isFileExist(fullPath)。

这次修正保留字节码中的可观察调用顺序；不改变后续存在性判断、读取、清理和数字转换逻辑。源码已重新写入 GitHub，仍为首版草稿、未运行时验证。


## 检查点 #130：两函数独立复核与 ReadNumericConfig 返回路径校正

### FormatStateChange 复核结果

复核 `root.children[8]` 的10条物理指令：
- PC1 读取 UP[0]（回调）并准备调用链。
- PC2-PC3 取得 `string.format`。
- PC4 准备格式串 `状态切换: %s -> %s`。
- PC5 读取 UP[1]（旧状态捕获单元）。
- PC6 读取 R0；该函数首个显式参数用于新状态。
- PC7 调用 string.format，并将其返回值写入 T[2] 起始的调用参数区。
- PC8 以 UP[0] 为目标，使用从 T[2] 开始的开放参数区发起调用；结合 PC7 的返回值落栈，草稿将格式化消息作为回调实参。
- PC9 将 R0 写回 UP[1]，发生在回调调用之后。
- PC10 return。

因此，草稿中的先格式化、再回调、最后更新捕获状态的顺序得到物理PC支持。捕获来源仍为父root PC181处的R4/R14；原始局部变量名及业务语义不臆造。vararg标志为1，额外变参未见被主体读取。状态保持首版草稿，未运行时验证。

### ReadNumericConfig 复核与修正

复核 `root.children[9]` 全部45条物理指令，发现首版草稿的三个返回分支表达错误，已修正源码 `04_源码候选/root9_ReadNumericConfig.lua`：

1. 文件不存在：PC11在条件不成立时跳过PC12；PC13清理T[3]，PC14返回清理后的T[3]，即nil，而不是false。
2. 文件读取结果不是string：PC21跳过PC22；PC23清理T[4]，PC24返回清理后的T[4]，即nil，而不是原始非字符串结果。
3. 去空白后不匹配 `^%d+$`：PC37跳过PC38；PC39清理T[4]，PC40返回清理后的T[4]，即nil，而不是归一化字符串。
4. 仅当模式匹配时，PC41-PC43调用tonumber并直接返回其结果。
5. 文件存在路径顺序保持：PC1-PC4先取得FileUtils单例；PC5-PC7调用UP[0] GetWritablePath；PC8-PC10调用isFileExist。
6. string.gsub的首个返回值被后续string.match使用；替换计数不参与结果。

以上按反汇编提供的OP_248清理与OP_220返回语义还原。尚未运行时验证；若宿主VM的T栈辅助函数实现与反汇编语义存在差异，需在完整解释器证据或运行时验证阶段再确认。

## 统计与接续

- 普通Lua草稿：78（本批复核既有原型，不新增计数）。
- 完整静态恢复：69/110（62.7%），不变。
- 运行时验证：0，不变。
- 下一步：批量复核/整理已有短函数草稿；随后对BlacklistPlayerDetection（root.children[47]）与StorageItems（root.children[50]）优先产出主体草稿，不因局部疑难停滞。
