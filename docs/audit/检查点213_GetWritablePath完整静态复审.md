# 检查点 #213：GetWritablePath 简单函数完整静态恢复

日期：2026-11-10
原型：`root.children[2]`（legacy `root/3`）
物理指令：10；常量：4；子原型：0；`vararg_flag=1`。

## 恢复结果

```lua
local function GetWritablePath(...)
    local fileUtils = cc.FileUtils:getInstance()
    local writablePath = fileUtils:getWritablePath()
    local path = ...
    return writablePath .. path
end
```

## 逐指令证据

- PC1：读取环境对象 `cc`。
- PC2：读取 `cc.FileUtils`。
- PC3-PC4：调用 `FileUtils:getInstance()`，保留实例接收者。
- PC5-PC6：读取并调用实例方法 `getWritablePath()`，取得可写目录前缀。
- PC7：将函数首个显式可变参数槽复制到 R2；调用点确认该值是路径/文件名。
- PC8：融合拼接指令按 `T[1] .. R2` 顺序拼接；结合 PC6 的可写目录返回值，结果为 `writablePath .. path`，不是反向拼接。
- PC9：返回拼接结果。
- PC10：PC9 返回后的尾部 return，不可达。

## 调用点交叉核对

- `ReadNumericConfig`（`root.children[9]`）以唯一显式参数 `fileName` 调用该闭包，并将结果用于 `FileUtils:isFileExist` 与 `getStringFromFile`。
- `FileExistCheck_pcall_wrapper`（`root.children[0]`）也将路径参数传入该闭包，随后用拼接结果进行文件存在检查及删除操作。
- `vararg_flag=1` 保留为 `...`；函数体只读取第一个可变参数。没有证据支持改成固定形参声明，因此源码保留 vararg 形式。

## 状态

10条物理指令的活动路径、方法接收者、首个路径参数及拼接方向完成静态闭合。升级为**完整静态恢复（未运行时验证）**。未执行目标游戏运行时验证，不计入运行时验证数量。

源码：`04_源码候选/root2_GetWritablePath.lua`
集中源码：`04_源码候选/MainLeftBottom_恢复源码.lua`
下一步：继续从未完成静态恢复的短函数中挑选无子原型、少捕获的目标；复杂 UI/状态机函数留到最后。
