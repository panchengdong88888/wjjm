# 检查点 #22：ShowLocalNoticeByType 捕获来源闭合

日期：2026-11-08

## 复核对象
`root.children[20]` / legacy `root/21` / ShowLocalNoticeByType，15 条指令。

## 父级创建点
在 root 初始化函数中：
- PC46 创建 child-index 20，即 `root.children[20]`。
- 创建指令标注 captures=1。
- PC47 紧随其后的 OP_387 捕获描述为 parent T[0]。
- 子函数 PC7–10 读取 UP[0].screenH，并计算 `screenH - 50)。

因此此前“UP[0] 的父级捕获来源未知”已解决：其来源是 root initializer 的 T[0]。由于 T[0] 的领域名称未由现有静态材料证明，源码工厂参数采用中性名称 `capturedScreenObject`，不臆造对象名。

## 已闭合的普通 Lua 语义
```lua
local function make_ShowLocalNoticeByType(capturedScreenObject)
    return function(message)
        local notice = {
            Type = 10,
            Msg = message,
            FColor = 249,
            BColor = 0,
            X = 5,
            Y = capturedScreenObject.screenH - 50,
        }
        SL.ShowLocalNoticeByType(notice)
    end
end
```

通知表字段、唯一捕获对象、Y 计算、SL helper 调用及单参数调用均已闭合。状态提升为完整静态恢复（未运行时验证）。
