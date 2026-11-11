# 检查点 #178：ReadNumericConfig 捕获来源与配置文件调用链闭合

日期：2026-11-10
原型：root.children[9]（legacy root/10）
函数：ReadNumericConfig
物理指令：45；常量：13；子原型：0；vararg_flag=1。

## 父 root 创建点与唯一捕获

- root PC297创建 root.children[2] / GetWritablePath，捕获数为0，结果进入父级R44。
- root PC298创建 root.children[9] / ReadNumericConfig，捕获数为1。
- 紧随其后的root PC299捕获父级R44，因此ReadNumericConfig的UP[0]精确指向刚创建的GetWritablePath闭包。
- ReadNumericConfig PC5-PC7以首个显式参数fileName调用UP[0]，并将其单个结果作为fullPath；随后同一路径用于FileUtils:isFileExist和FileUtils:getStringFromFile。GetWritablePath本体已在检查点127独立完成静态复核：PC7读取首个路径参数，PC8按writablePath .. path顺序拼接，PC9返回；此处调用结果语义与既有复核一致。

## 上层配置读取包装器

- root PC295将常量字符串blacklist_distance.txt写入R42。
- root PC304创建root.children[49] / AnonymousHelper_49，捕获数为2；PC305捕获R45（ReadNumericConfig闭包），PC306捕获R42（blacklist_distance.txt）。
- AnonymousHelper_49的5条指令：PC1读取UP[0]函数，PC2读取UP[1]文件名，PC3调用ReadNumericConfig(fileName)并直接返回其结果；PC4-PC5位于返回之后，不可达。
- 该包装器随后作为doInit_UI中读取黑名单距离配置的回调传递；不将其误判为直接在root初始化阶段立即读取文件。

## ReadNumericConfig逐指令结论

- PC1-PC4：取得cc.FileUtils:getInstance()单例，保留FileUtils作为后续方法接收者。
- PC5-PC7：调用UP[0]=GetWritablePath，唯一显式实参为fileName，接收返回路径。
- PC8-PC14：调用fileUtils:isFileExist(fullPath)；文件不存在分支清理返回槽并返回nil，不返回false。
- PC15-PC24：调用fileUtils:getStringFromFile(fullPath)，要求结果类型严格为string；非字符串分支清理返回槽并返回nil。
- PC25-PC36：string.gsub(content, "%s", "")移除所有Lua空白字符，再以string.match(normalized, "^%d+$")判断是否为非空ASCII数字串。
- PC37-PC40：正则不匹配时清理返回槽并返回nil。
- PC41-PC43：匹配时调用tonumber(normalized)并返回数值。
- PC44-PC45：尾部指令不改变上述活动返回路径；逐PC对照保持原有审计结论。
- vararg_flag=1，但额外变参未读取。

## 状态结论

唯一捕获函数身份、参数传递、FileUtils接收者、三类nil失败分支及数字成功分支均闭合；上层AnonymousHelper_49的文件名与转发调用亦已核对。升级为完整静态恢复（未运行时验证）。GetWritablePath自身的内部参数拼接方向留待其独立复审，不将不确定语义外推到本函数。

源码：04_源码候选/root9_ReadNumericConfig.lua
计数：普通Lua草稿76；完整静态恢复97/110；运行时验证0。
下一步：复核root.children[2] / GetWritablePath（10条），利用ReadNumericConfig和FileExistCheck_pcall_wrapper两个调用点闭合vararg路径参数及拼接方向。
