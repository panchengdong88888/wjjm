# 检查点 #103：Nested_Helper_2数值格式化静态复核

日期：2026-11-09  
函数：Nested_Helper_2  
规范路径：`root.children[42].children[3].children[0]`  
legacy：`root/43/4/1`  
物理指令：35；常量：12；子原型：0；vararg_flag=1；无捕获。

## 分支逐PC核对
- PC1-PC3：首个参数false/nil时写入数值0；truthy参数保留。
- PC4-PC10：小于100000时调用tostring并返回。
- PC11-PC21：不小于100000且小于100000000时，执行`math.floor(value/10000)`，拼接常量“万”，返回。
- PC23-PC34：不小于100000000时，先计算`math.floor(value/100000000*10)/10`，再调用`string.format("%.1f亿", scaled)`并返回。
- PC35：尾部return，不改变前述显式返回路径。

## 等价源码
```lua
local function Nested_Helper_2(...)
    local value = ...
    if not value then value = 0 end

    if value < 100000 then
        return tostring(value)
    end

    if value < 100000000 then
        return tostring(math.floor(value / 10000)) .. "万"
    end

    local scaled = math.floor(value / 100000000 * 10) / 10
    return string.format("%.1f亿", scaled)
end
```

## 边界说明
- 这是按字节码可见比较符与算术次序恢复，不补充四舍五入；亿级分支明确先floor到一位小数。
- vararg_flag=1，字节码使用首个参数作为数值；多余变参未参与计算。
- 输入若为非数字truthy值，比较操作可能按Lua运行时规则报错；字节码未做类型保护，不擅自添加。
- 无闭包捕获；35条指令控制流、分支和返回已闭合。

状态：完整静态恢复（未运行时验证）。无宿主运行时验证。
