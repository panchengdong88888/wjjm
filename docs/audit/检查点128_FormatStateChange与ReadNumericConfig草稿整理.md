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
