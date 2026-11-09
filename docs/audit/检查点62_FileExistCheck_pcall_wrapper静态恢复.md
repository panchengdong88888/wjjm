# 检查点 #62：FileExistCheck_pcall_wrapper 静态恢复

日期：2026-11-09

## 对象身份
- 原型索引：1
- 规范路径：`root.children[0]`
- legacy 路径：`root/1`
- 名称：`FileExistCheck_pcall_wrapper`
- 物理指令：32
- 常量：5
- 子原型：1
- vararg_flag：1

## 父级捕获关系
- 根原型 PC302 创建本函数，捕获数为1。
- PC303 将父级 R44 捕获为本函数 UPVALUE_0。
- 根原型 PC297 的 R44 是 `root.children[2]`（legacy `root/3`）闭包。
- `root/3` 的10条指令明确执行 `cc.FileUtils:getInstance():getWritablePath()`，并将结果与传入参数拼接后返回。
- 因此本函数 UPVALUE_0 的可观察语义是“生成 writable path 前缀后的路径”，草稿中临时命名为 `resolveWritablePath`；未声称这是作者原始变量名。

## 主体控制流
1. 获取 `cc.FileUtils:getInstance()`。
2. 调用 UPVALUE_0(path) 得到 resolvedPath。
3. 首次调用 `fileUtils:isFileExist(resolvedPath)`：
   - 真值分支返回 `true, resolvedPath`。
   - 假值分支继续。
4. 通过 `pcall` 执行子闭包；子闭包调用 `fileUtils:removeFile(resolvedPath)`。
5. 若 pcall 的第一个返回值为假，立即返回 `false, resolvedPath`。
6. 若 pcall 成功，再次调用 `isFileExist`，对结果取逻辑非，返回 `not exists, resolvedPath`。

## 子原型捕获
- 子原型：`root.children[0].children[0]`（legacy `root/1/1`），5条指令。
- 创建点 root/1 PC17，捕获数2。
- PC18：子闭包 UPVALUE_0 捕获父函数 R1，即 FileUtils 实例。
- PC19：子闭包 UPVALUE_1 捕获父函数 R2，即 resolvedPath。
- 子函数取 UPVALUE_0.removeFile，并以 UPVALUE_1 为参数调用；根据对象方法调用约定恢复为 `fileUtils:removeFile(resolvedPath)`。
- 父函数 PC20 将该闭包作为唯一参数交给 `pcall`；pcall 的返回状态决定是否进入二次文件存在检查。

## 结论与限制
- if/return 控制流闭合，两个返回值的来源可定位。
- writable path 处理闭包及删除闭包的捕获链均已闭合。
- `vararg_flag=1` 保留在原型元数据中；主体只读取首个参数寄存器，未发现显式消费额外 varargs 的指令。草稿签名暂保留 `...`，不推断其余参数用途。
- 本函数升级为“完整静态恢复（未运行时验证）”。
- 未在原宿主环境执行；运行时验证计数保持0。

## 文件
- 源码：`04_源码候选/短函数草稿_第三十八批.lua`
- 状态索引：`02_基础索引/03_函数状态清单.csv`
- 机器状态：`docs/handoff/05_机器可读接续状态.json`
- 协议：`docs/handoff/10_防上下文中断_checkpoint协议.md`
