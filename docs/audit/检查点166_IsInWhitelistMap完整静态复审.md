# 检查点166：IsInWhitelistMap 28条指令独立静态复审

日期：2026-11-09（Asia/Singapore）
对象：`root.children[31]`（legacy `root/32`），28条物理指令，6个常量，无upvalue、无子原型。

## 1. 安全区域优先分支（PC1-PC8）

- PC1-PC2取得SL.GetMetaValue方法并保留SL接收者。
- PC3加载键名`IN_SAFE_AREA`。
- PC4调用`SL:GetMetaValue("IN_SAFE_AREA")`。
- PC5检查返回值truthy；truthy路径跳过PC6跳转，PC7加载true，PC8立即返回true。
- false/nil路径执行PC6跳至PC9，继续读取地图名称。

## 2. 地图名称与白名单构造（PC9-PC18）

- PC9-PC12再次以SL为接收者调用GetMetaValue，唯一显式参数为`"MAP_NAME"`。
- PC13建立新表。
- PC14加载唯一白名单常量`"土城"`。
- PC15将其作为数组第1项写入表，等价于`local whitelist = {"土城"}`。
- PC16-PC18取得ipairs并以白名单表建立泛型for迭代器。

## 3. 白名单循环与返回（PC19-PC28）

- PC19进入循环判断。
- PC20比较当前mapName与当前allowedMapName。
- PC21不匹配时跳至PC24，继续迭代。
- 匹配时PC22加载true，PC23立即返回true。
- PC24-PC25推进ipairs循环并回到PC20。
- 遍历结束后PC26加载false，PC27返回false。
- PC28位于PC27 return之后，为不可达尾部return。

## 4. 等价普通Lua与结论

```lua
local function IsInWhitelistMap()
    if SL:GetMetaValue("IN_SAFE_AREA") then
        return true
    end

    local mapName = SL:GetMetaValue("MAP_NAME")
    local whitelist = {"土城"}

    for _, allowedMapName in ipairs(whitelist) do
        if mapName == allowedMapName then
            return true
        end
    end

    return false
end
```

- 28条物理指令的活动路径、SL方法receiver、元数据键名、安全区域分支、白名单数组构造、ipairs比较及真假返回极性闭合。
- 白名单数组当前只有一个常量“土城”，不扩展为其他地图。
- PC28不生成额外源码分支。

结论：升级为**完整静态恢复（未运行时验证）**。未在游戏中验证安全区域元数据和地图名取值。

## 5. 统计与下一步

- 普通Lua源码候选：82（不变）
- 完整静态恢复：87/110（由86增加1）
- 运行时验证：0（不变）

下一步：继续从未完成短函数中筛选可闭合目标；优先检查`root.children[24]` UseItemByIndex（33条）与`root.children[10]` SetButtonVisibilityState已完成，避免重复已静态恢复项目。
