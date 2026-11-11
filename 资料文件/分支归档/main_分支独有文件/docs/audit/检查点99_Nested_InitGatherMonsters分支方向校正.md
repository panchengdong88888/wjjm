# 检查点 #99：Nested_InitGatherMonsters分支方向校正

日期：2026-11-09  
函数：Nested_InitGatherMonsters  
规范路径：`root.children[42].children[7]`  
legacy：`root/43/8`  
物理指令：17；常量：2；子原型：0；vararg_flag=1。

## 捕获来源
doInit_UI PC245创建该闭包，PC246-PC247均为OP_325，依次捕获父UP[8]与UP[9]：
- UP[0]：配置/状态表，读取并写入GATHER_THRESHOLD。
- UP[1]：无参阈值获取回调。
业务原始局部变量名未确认，保留按行为命名。

## 正确控制流

### 刷新阈值（PC1-PC6）
- PC1读取UP[0]配置表。
- PC2检查参数refreshFlag是否truthy。
- refreshFlag为true时，PC3跳转至PC6，跳过getter。
- refreshFlag为false/nil时，PC2跳过PC3，PC4-PC5调用UP[1]()，PC6将返回值写入config.GATHER_THRESHOLD。

因此只有refreshFlag为假时才刷新阈值。

### 阈值分支（PC7-PC17）
- PC7-PC8读取config.GATHER_THRESHOLD。
- PC9检查该字段truthy。
- 字段为false/nil时，PC9跳过PC10无条件跳转，执行PC11-PC12返回false。
- 字段truthy时，PC10跳转PC13，调用全局InitGatherMonsters()，PC15-PC16返回true。
- PC17是两个显式返回路径之后的尾部return，不产生额外返回值。

**本轮纠正了首版草稿的反向错误**：此前把“阈值truthy”写成return false，把“阈值缺失”写成调用InitGatherMonsters；实际字节码恰好相反。

## 完整等价表达
```lua
local function Nested_InitGatherMonsters(refreshFlag)
    local config = UPVALUE_0
    local getThreshold = UPVALUE_1

    if not refreshFlag then
        config.GATHER_THRESHOLD = getThreshold()
    end

    if config.GATHER_THRESHOLD then
        InitGatherMonsters()
        return true
    end

    return false
end
```

## 状态
17条指令的捕获读取、刷新条件、truthy分支、调用、返回值全部闭合，升级“完整静态恢复（未运行时验证）”。UP[0]/UP[1]的原始业务变量名未恢复，不影响本函数控制流与调用语义。无游戏客户端运行时验证。
