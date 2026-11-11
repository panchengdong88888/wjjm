# 检查点 #19：FriendProxy pcall 包装器恢复

日期：2026-11-08

新增到 `04_源码候选/代理与回调短函数_第四批.lua`：`root.children[48]` / legacy root/49 / PCallHelper_2（10 条指令）。

## 恢复结果

- PC1 取全局 `pcall`。
- PC2 创建无捕获、无参数子闭包 Nested_FriendProxy。
- PC3 执行 `pcall(Nested_FriendProxy)`，接收成功标志与第二返回值。
- PC4–5：pcall 失败时跳过结果读取，结果寄存器保持 nil。
- PC6–7：成功时仅在子函数结果 truthy 时复制结果；false/nil 仍保持 nil。
- PC8–9：返回结果寄存器。
- 子闭包 Nested_FriendProxy 已恢复为 `global.Facade.retrieveProxy(global.ProxyTable.FriendProxy)`。

等价普通 Lua：
```lua
local function PCallHelper_2()
    local ok, result = pcall(Nested_FriendProxy)
    if not ok then return nil end
    return result or nil
end
```

静态控制流、返回值归一化及子闭包调用关系已闭合，标记完整静态恢复（未运行时验证）。
