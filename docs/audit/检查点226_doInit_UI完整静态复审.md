# 检查点 #226：doInit_UI 419条父指令完整静态复审

日期：2026-11-10
原型：`root.children[42]`（legacy `root/43`）
物理指令：419；常量：105；子原型：23；父级捕获：20。

## 显式捕获工厂

原草稿使用未定义全局`UP`表读取UP[0..19]，无法独立实例化。本批改为：

```lua
local function make_doInit_UI(upvalue0, upvalue1, upvalue2, upvalue3, upvalue4,
    upvalue5, upvalue6, upvalue7, upvalue8, upvalue9,
    upvalue10, upvalue11, upvalue12, upvalue13, upvalue14,
    upvalue15, upvalue16, upvalue17, upvalue18, upvalue19)
    local function doInit_UI()
        -- PC1-PC419主体
    end
    return doInit_UI
end
```

20项顺序按root PC390：`T[4],T[2],T[3],T[0],T[1],T[41],T[48],T[7],T[8],T[50],T[49],T[5],T[44],T[42],T[51],T[43],T[47],T[11],T[12],T[9]`。

## T7与GUI调用

- PC90调用R4，单实参T[5]，多返回值写入T[4..T[6]]。
- PC133调用标准Lua`ipairs(T[6])`并取得第三返回值。标准Lua ipairs返回iterator、table、0；模块内未发现覆盖ipairs的赋值，因此T7按0恢复。
- PC180 `storageProxy:RequestStorageData(T7)`、PC183 `GUI:Attach_UITop(T7)`均只传一个实参0，保留字节码调用形态。
- 开发文档`GUI/常用方法.md`签名为`Attach_UITop()`，无必需参数；额外0实参按原字节码保留。RequestStorageData未在开发文档中找到，按引擎内部API原样保留。

## 子原型边界

- child11 Nested_Helper_4和child14 Nested_Helper_7的工厂及其成功回调Nested_Helper_5/Nested_Helper_8已在本文件上方定义；删除原草稿过期TODO。
- child3 Nested_FFFF00已于检查点225完成静态恢复。
- child22 Nested_Anonymous仍有独立T槽映射问题，特别是T2错误提示回调来源未找到。它不影响本次父函数PC1-PC419的静态指令映射，但仍单独保持pending。

## 结论

doInit_UI父函数419条物理指令完整静态恢复；20项捕获显式工厂化。没有Lua解释器或游戏客户端运行时验证。
